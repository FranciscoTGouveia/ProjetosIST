#include "operations.h"
#include "config.h"
#include "state.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

#include "betterassert.h"

tfs_params tfs_default_params() {
    tfs_params params = {
        .max_inode_count = 64,
        .max_block_count = 1024,
        .max_open_files_count = 16,
        .block_size = 1024,
    };
    return params;
}

int tfs_init(tfs_params const *params_ptr) {
    tfs_params params;
    if (params_ptr != NULL) {
        params = *params_ptr;
    } else {
        params = tfs_default_params();
    }

    if (state_init(params) != 0) {
        return -1;
    }

    // create root inode
    int root = inode_create(T_DIRECTORY);
    if (root != ROOT_DIR_INUM) {
        return -1;
    }

    return 0;
}

int tfs_destroy() {
    if (state_destroy() != 0) {
        return -1;
    }
    return 0;
}

static bool valid_pathname(char const *name) {
    return name != NULL && strlen(name) > 1 && name[0] == '/';
}

/**
 * Looks for a file.
 *
 * Note: as a simplification, only a plain directory space (root directory
 * only) is supported.
 *
 * Input:
 *   - name: absolute path name
 *   - root_inode: the root directory inode
 * Returns the inumber of the file, -1 if unsuccessful.
 */
static int tfs_lookup(char const *name, inode_t const *root_inode) {
    // TODO: assert that root_inode is the root directory
    if (!valid_pathname(name)) {
        return -1;
    }

    // skip the initial '/' character
    name++;

    return find_in_dir(root_inode, name);
}

int tfs_open(char const *name, tfs_file_mode_t mode) {
    // Checks if the path name is valid
    if (!valid_pathname(name)) {
        return -1;
    }
    inode_t *root_dir_inode = inode_get(ROOT_DIR_INUM);
    ALWAYS_ASSERT(root_dir_inode != NULL,
                  "tfs_open: root dir inode must exist");
    int inum = tfs_lookup(name, root_dir_inode);
    size_t offset;

    if (inum >= 0) {
        // The file already exists
        pthread_rwlock_t *lock = inode_lock_get(inum);
        my_w_lock(lock);
        inode_t *inode = inode_get(inum);
        ALWAYS_ASSERT(inode != NULL,
                      "tfs_open: directory files must have an inode");
        if (inode->i_node_type == T_SOFT_LINK) {
            inum = get_path_recursive(inum);
            my_unlock(lock);
            if (inum == -1) {
                return -1;
            }
            lock = inode_lock_get(inum);
            my_r_lock(lock);
            inode = inode_get(inum);
        }
        // Truncate (if requested)
        if (mode & TFS_O_TRUNC) {
            if (inode->i_size > 0) {
                data_block_free(inode->i_data_block);
                inode->i_size = 0;
            }
        }
        // Determine initial offset
        if (mode & TFS_O_APPEND) {
            offset = inode->i_size;
        } else {
            offset = 0;
        }
        my_unlock(lock);
    } else if (mode & TFS_O_CREAT) {
        // The file does not exist; the mode specified that it should be
        // created Create inode
        inum = inode_create(T_FILE);
        if (inum == -1) {
            return -1; // no space in inode table
        }

        // Add entry in the root directory
        if (add_dir_entry(root_dir_inode, name + 1, inum) == -1) {
            inode_delete(inum);
            return -1; // no space in directory
        }

        offset = 0;
    } else {
        return -1;
    }

    // Finally, add entry to the open file table and return the corresponding
    // handle
    return add_to_open_file_table(inum, offset);

    // Note: for simplification, if file was created with TFS_O_CREAT and
    // there is an error adding an entry to the open file table, the file is
    // not opened but it remains created
}

/**
 * @brief Soft links a file to a another
 * @note If the target file doesn't exist then it will return -1
 * @param target absolute target path name
 * @param link_name absolute linked path name
 * @return 0 if successeful, -1 if it doesn't
 */
int tfs_sym_link(char const *target, char const *link_name) {
    inode_t *root_dir_inode = inode_get(ROOT_DIR_INUM);
    if (root_dir_inode == NULL) {
        return -1;
    }
    int inumber_target = tfs_lookup(target, root_dir_inode);
    if (inumber_target == -1) {
        return -1;
    }
    pthread_rwlock_t *lock_target = inode_lock_get(inumber_target);
    my_r_lock(lock_target);
    int inumber = inode_create(T_SOFT_LINK);
    if (inumber == -1) {
        my_unlock(lock_target);
        return -1;
    }
    pthread_rwlock_t *lock = inode_lock_get(inumber);
    my_w_lock(lock);
    inode_t *inode = inode_get(inumber);
    if (inode == NULL) {
        my_unlock(lock_target);
        my_unlock(lock);
        return -1;
    }
    void *block = data_block_get(inode->i_data_block);
    if (block == NULL) {
        my_unlock(lock_target);
        my_unlock(lock);
        return -1;
    }
    strcpy(block, target);
    add_dir_entry(root_dir_inode, link_name + 1, inumber);
    my_unlock(lock_target);
    my_unlock(lock);
    return 0;
}

/**
 * @brief Hard links a file to another
 * @note If the target file doesn't exist then it will return -1
 * @param target absolute target path name
 * @param link_name absolute linked path name
 * @return 0 if successeful, -1 if it doesn't
 */
int tfs_link(char const *target, char const *link_name) {
    inode_t *root_dir_inode = inode_get(ROOT_DIR_INUM);
    if (root_dir_inode == NULL) {
        return -1;
    }
    int inumber = tfs_lookup(target, root_dir_inode);
    if (inumber == -1) {
        return -1;
    }
    pthread_rwlock_t *lock = inode_lock_get(inumber);
    my_w_lock(lock);
    inode_t *inode = inode_get(inumber);
    if (inode == NULL) {
        my_unlock(lock);
        return -1;
    }
    if (inode->i_node_type == T_SOFT_LINK) {
        my_unlock(lock);
        return -1;
    }
    inode->i_count++;
    add_dir_entry(root_dir_inode, link_name + 1, inumber);
    my_unlock(lock);
    return 0;
}

int tfs_close(int fhandle) {
    open_file_entry_t *file = get_open_file_entry(fhandle);
    if (file == NULL) {
        return -1; // invalid fd
    }
    pthread_rwlock_t *lock_f = get_open_file_lock(fhandle);
    my_w_lock(lock_f);
    remove_from_open_file_table(fhandle);
    my_unlock(lock_f);
    return 0;
}

ssize_t tfs_write(int fhandle, void const *buffer, size_t to_write) {
    open_file_entry_t *file = get_open_file_entry(fhandle);
    if (file == NULL) {
        return -1;
    }
    //  From the open file table entry, we get the inode
    pthread_rwlock_t *lock = inode_lock_get(file->of_inumber);
    my_w_lock(lock);
    pthread_rwlock_t *lock_f = get_open_file_lock(fhandle);
    my_w_lock(lock_f);
    inode_t *inode = inode_get(file->of_inumber);
    ALWAYS_ASSERT(inode != NULL, "tfs_write: inode of open file deleted");
    // Determine how many bytes to write
    size_t block_size = state_block_size();
    if (to_write + file->of_offset > block_size) {
        to_write = block_size - file->of_offset;
    }

    if (to_write > 0) {
        if (inode->i_size == 0) {
            // If empty file, allocate new block
            int bnum = data_block_alloc();
            if (bnum == -1) {

                my_unlock(lock);
                my_unlock(lock_f);
                return -1; // no space
            }

            inode->i_data_block = bnum;
        }

        void *block = data_block_get(inode->i_data_block);
        ALWAYS_ASSERT(block != NULL,
                      "tfs_write: data block deleted mid-write");

        // Perform the actual write
        memcpy(block + file->of_offset, buffer, to_write);

        // The offset associated with the file handle is incremented
        // accordingly
        file->of_offset += to_write;
        if (file->of_offset > inode->i_size) {
            inode->i_size = file->of_offset;
        }
    }

    my_unlock(lock);
    my_unlock(lock_f);
    return (ssize_t)to_write;
}

ssize_t tfs_read(int fhandle, void *buffer, size_t len) {
    open_file_entry_t *file = get_open_file_entry(fhandle);
    if (file == NULL) {
        return -1;
    }

    // From the open file table entry, we get the inode
    pthread_rwlock_t *lock = inode_lock_get(file->of_inumber);
    my_r_lock(lock);
    pthread_rwlock_t *lock_f = get_open_file_lock(fhandle);
    my_r_lock(lock_f);
    inode_t const *inode = inode_get(file->of_inumber);
    ALWAYS_ASSERT(inode != NULL, "tfs_read: inode of open file deleted");
    // Determine how many bytes to read
    size_t to_read = inode->i_size - file->of_offset;
    if (to_read > len) {
        to_read = len;
    }

    if (to_read > 0) {
        void *block = data_block_get(inode->i_data_block);
        ALWAYS_ASSERT(block != NULL, "tfs_read: data block deleted mid-read");
        if (((char *)(block + file->of_offset))[0] == '\0') {
            file->of_offset++;
        }
        if (memchr(block + file->of_offset, 0, to_read) != NULL) {
            to_read = (size_t)(memchr(block + file->of_offset, 0, to_read) -
                               (block + file->of_offset));
        }
        // Perform the actual read
        memcpy(buffer, block + file->of_offset, to_read);
        // The offset associated with the file handle is incremented
        // accordingly
        file->of_offset += to_read;
    }
    my_unlock(lock);
    my_unlock(lock_f);
    return (ssize_t)to_read;
}

/**
 * @brief Unlinks or deletes a file, depending in its hard link counter and in
 * its type
 *
 * @param target absolute target path name
 * @return 0 if successeful, -1 if it doesn't
 */
int tfs_unlink(char const *target) {
    inode_t *root = inode_get(ROOT_DIR_INUM);
    if (root == NULL) {
        return -1;
    }
    int inumber = tfs_lookup(target, root);
    if (inumber == -1) {
        return -1;
    }
    pthread_rwlock_t *lock = inode_lock_get(inumber);
    my_w_lock(lock);
    inode_t *inode = inode_get(inumber);
    if (inode == NULL) {
        my_unlock(lock);
        return -1;
    }
    clear_dir_entry(root, target + 1);
    if (inode->i_count > 1) {
        inode->i_count--;
    } else {
        inode_delete(inumber);
    }
    my_unlock(lock);
    return 0;
}

/**
 * @brief Copies a file from another file system to ist's one
 * @note Reads from the source file 1024 bytes at a time
 * @param source_path absolute source path name
 * @param dest_path absolute destiny path name
 * @return 0 if successeful, -1 if it doesn't
 */
int tfs_copy_from_external_fs(char const *source_path,
                              char const *dest_path) {
    char buffer[1024];
    FILE *file = fopen(source_path, "r");
    if (file == NULL) {
        return -1;
    }

    int outd = tfs_open(dest_path, TFS_O_CREAT | TFS_O_TRUNC);
    if (outd == -1) {
        return -1;
    }
    size_t bytes_read;
    ssize_t bytes_written;
    while ((bytes_read = fread(buffer, sizeof(char), sizeof(buffer), file)) >
           0) {
        bytes_written = tfs_write(outd, buffer, (size_t)bytes_read);
        if (bytes_written != bytes_read) {
            return -1;
        }
    }

    fclose(file);
    tfs_close(outd);
    return 0;
}
