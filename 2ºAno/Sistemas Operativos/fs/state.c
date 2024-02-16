#include "state.h"
#include "betterassert.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>

/*
 * Persistent FS state
 * (in reality, it should be maintained in secondary memory;
 * for simplicity, this project maintains it in primary memory).
 */
static tfs_params fs_params;

// Inode table
static inode_t *inode_table;
static allocation_state_t *freeinode_ts;
static pthread_rwlock_t *lock_inode;
static pthread_rwlock_t lock_inode_table;

// Data blocks
static char *fs_data; // # blocks * block size
static allocation_state_t *free_blocks;
static pthread_rwlock_t lock_data_table;
static pthread_rwlock_t lock_dir_table;

static pthread_rwlock_t *lock_file;

/*
 * Volatile FS state
 */
static open_file_entry_t *open_file_table;
static allocation_state_t *free_open_file_entries;
static pthread_rwlock_t lock_file_table;
// Convenience macros
#define INODE_TABLE_SIZE (fs_params.max_inode_count)
#define DATA_BLOCKS (fs_params.max_block_count)
#define MAX_OPEN_FILES (fs_params.max_open_files_count)
#define BLOCK_SIZE (fs_params.block_size)
#define MAX_DIR_ENTRIES (BLOCK_SIZE / sizeof(dir_entry_t))

static inline bool valid_inumber(int inumber) {
    return inumber >= 0 && inumber < INODE_TABLE_SIZE;
}

static inline bool valid_block_number(int block_number) {
    return block_number >= 0 && block_number < DATA_BLOCKS;
}

static inline bool valid_file_handle(int file_handle) {
    return file_handle >= 0 && file_handle < MAX_OPEN_FILES;
}

size_t state_block_size(void) { return BLOCK_SIZE; }

/**
 * Do nothing, while preventing the compiler from performing any
 * optimizations.
 *
 * We need to defeat the optimizer for the insert_delay() function.
 * Under optimization, the empty loop would be completely optimized away.
 * This function tells the compiler that the assembly code being run (which is
 * none) might potentially change *all memory in the process*.
 *
 * This prevents the optimizer from optimizing this code away, because it does
 * not know what it does and it may have side effects.
 *
 * Reference with more information: https://youtu.be/nXaxk27zwlk?t=2775
 *
 * Exercise: try removing this function and look at the assembly generated to
 * compare.
 */
static void touch_all_memory(void) { __asm volatile("" : : : "memory"); }

/**
 * Artifically delay execution (busy loop).
 *
 * Auxiliary function to insert a delay.
 * Used in accesses to persistent FS state as a way of emulating access
 * latencies as if such data structures were really stored in secondary
 * memory.
 */
static void insert_delay(void) {
    for (int i = 0; i < DELAY; i++) {
        touch_all_memory();
    }
}

/**
 * Initialize FS state.
 *
 * Input:
 *   - params: TécnicoFS parameters
 *
 * Returns 0 if successful, -1 otherwise.
 *
 * Possible errors:
 *   - TFS already initialized.
 *   - malloc failure when allocating TFS structures.
 */
int state_init(tfs_params params) {
    fs_params = params;

    if (inode_table != NULL) {
        return -1; // already initialized
    }

    inode_table = malloc(INODE_TABLE_SIZE * sizeof(inode_t));
    lock_inode = (pthread_rwlock_t *)malloc(INODE_TABLE_SIZE *
                                            sizeof(pthread_rwlock_t));
    freeinode_ts = malloc(INODE_TABLE_SIZE * sizeof(allocation_state_t));
    fs_data = malloc(DATA_BLOCKS * BLOCK_SIZE);
    free_blocks = malloc(DATA_BLOCKS * sizeof(allocation_state_t));
    open_file_table = malloc(MAX_OPEN_FILES * sizeof(open_file_entry_t));
    lock_file = malloc(MAX_OPEN_FILES * sizeof(pthread_rwlock_t));
    free_open_file_entries =
        malloc(MAX_OPEN_FILES * sizeof(allocation_state_t));

    if (!inode_table || !freeinode_ts || !fs_data || !free_blocks ||
        !open_file_table || !free_open_file_entries) {
        return -1; // allocation failed
    }

    for (size_t i = 0; i < INODE_TABLE_SIZE; i++) {
        freeinode_ts[i] = FREE;
    }

    for (size_t i = 0; i < DATA_BLOCKS; i++) {
        free_blocks[i] = FREE;
    }

    for (size_t i = 0; i < MAX_OPEN_FILES; i++) {
        free_open_file_entries[i] = FREE;
    }

    for (size_t i = 0; i < INODE_TABLE_SIZE; i++) {
        pthread_rwlock_init(&lock_inode[i], NULL);
    }

    for (size_t i = 0; i < MAX_OPEN_FILES; i++) {
        pthread_rwlock_init(&lock_file[i], NULL);
    }

    return 0;
}

/**
 * Destroy FS state.
 *
 * Returns 0 if succesful, -1 otherwise.
 */
int state_destroy(void) {
    for (size_t i = 0; i < INODE_TABLE_SIZE; i++) {
        pthread_rwlock_destroy(&lock_inode[i]);
    }
    for (size_t i = 0; i < MAX_OPEN_FILES; i++) {
        pthread_rwlock_destroy(&lock_file[i]);
    }
    pthread_rwlock_destroy(&lock_inode_table);
    pthread_rwlock_destroy(&lock_dir_table);
    pthread_rwlock_destroy(&lock_data_table);
    pthread_rwlock_destroy(&lock_file_table);

    free(lock_file);
    free(lock_inode);
    free(inode_table);
    free(freeinode_ts);
    free(fs_data);
    free(free_blocks);
    free(open_file_table);
    free(free_open_file_entries);

    lock_file = NULL;
    inode_table = NULL;
    lock_inode = NULL;
    freeinode_ts = NULL;
    fs_data = NULL;
    free_blocks = NULL;
    open_file_table = NULL;
    free_open_file_entries = NULL;

    return 0;
}

/**
 * (Try to) Allocate a new inode in the inode table, without initializing its
 * data.
 *
 * Returns the inumber of the newly allocated inode, or -1 in the case of
 * error.
 *
 * Possible errors:
 *   - No free slots in inode table.
 */
static int inode_alloc(void) {
    my_w_lock(&lock_inode_table);
    for (size_t inumber = 0; inumber < INODE_TABLE_SIZE; inumber++) {
        if ((inumber * sizeof(allocation_state_t) % BLOCK_SIZE) == 0) {
            insert_delay(); // simulate storage access delay (to freeinode_ts)
        }

        // Finds first free entry in inode table
        if (freeinode_ts[inumber] == FREE) {
            //  Found a free entry, so takes it for the new inode
            freeinode_ts[inumber] = TAKEN;
            my_unlock(&lock_inode_table);
            return (int)inumber;
        }
    }

    // no free inodes
    my_unlock(&lock_inode_table);
    return -1;
}

/**
 * Create a new inode in the inode table.
 *
 * Allocates and initializes a new inode.
 * Directories will have their data block allocated and initialized, with
 * i_size set to BLOCK_SIZE. Regular files will not have their data block
 * allocated (i_size will be set to 0, i_data_block to -1).
 *
 * Input:
 *   - i_type: the type of the node (file or directory)
 *
 * Returns inumber of the new inode, or -1 in the case of error.
 *
 * Possible errors:
 *   - No free slots in inode table.
 *   - (if creating a directory) No free data blocks.
 */
int inode_create(inode_type i_type) {
    int inumber = inode_alloc();
    if (inumber == -1) {
        return -1; // no free slots in inode table
    }

    inode_t *inode = &inode_table[inumber];
    insert_delay(); // simulate storage access delay (to inode)

    inode->i_node_type = i_type;
    switch (i_type) {
        case T_DIRECTORY: {
            // Initializes directory (filling its block with empty entries,
            // labeled with inumber==-1)
            int b = data_block_alloc();
            if (b == -1) {
                // ensure fields are initialized
                inode->i_size = 0;
                inode->i_data_block = -1;

                // run regular deletion process
                inode_delete(inumber);
                return -1;
            }

            inode_table[inumber].i_size = BLOCK_SIZE;
            inode_table[inumber].i_data_block = b;

            dir_entry_t *dir_entry = (dir_entry_t *)data_block_get(b);
            ALWAYS_ASSERT(dir_entry != NULL,
                          "inode_create: data block freed while in use");

            for (size_t i = 0; i < MAX_DIR_ENTRIES; i++) {
                dir_entry[i].d_inumber = -1;
            }
        } break;
        case T_FILE:
            // In case of a new file, simply sets its size to 0
            inode_table[inumber].i_size = 0;
            inode_table[inumber].i_data_block = -1;
            inode_table[inumber].i_count = 1;
            break;

        case T_SOFT_LINK: {
            int b = data_block_alloc();
            if (b == -1) {
                inode->i_size = 0;
                inode->i_data_block = -1;

                inode_delete(inumber);
                return -1;
            }
            inode_table[inumber].i_count = 1;
            inode_table[inumber].i_size = MAX_FILE_NAME;
            inode_table[inumber].i_data_block = b;
        } break;
        default:
            PANIC("inode_create: unknown file type");
    }

    return inumber;
}

/**
 * Delete an inode.
 *
 * Input:
 *   - inumber: inode's number
 */
void inode_delete(int inumber) {
    // simulate storage access delay (to inode and freeinode_ts)
    insert_delay();
    insert_delay();
    my_w_lock(&lock_inode_table);
    ALWAYS_ASSERT(valid_inumber(inumber), "inode_delete: invalid inumber");

    ALWAYS_ASSERT(freeinode_ts[inumber] == TAKEN,
                  "inode_delete: inode already freed");

    if (inode_table[inumber].i_size > 0) {
        data_block_free(inode_table[inumber].i_data_block);
    }
    freeinode_ts[inumber] = FREE;
    my_unlock(&lock_inode_table);
}

/**
 * Obtain a pointer to an inode from its inumber.
 *
 * Input:
 *   - inumber: inode's number
 *
 * Returns pointer to inode.
 */
inode_t *inode_get(int inumber) {
    ALWAYS_ASSERT(valid_inumber(inumber), "inode_get: invalid inumber");
    insert_delay(); // simulate storage access delay to inode
    my_r_lock(&lock_inode_table);
    inode_t *phi = &inode_table[inumber];
    my_unlock(&lock_inode_table);
    return phi;
}

/**
 * @brief Obtains a pointer to a lock from its inumber
 *
 * @param inumber lock's respective inumber
 * @return pointer to lock
 */
pthread_rwlock_t *inode_lock_get(int inumber) { return &lock_inode[inumber]; }

/**
 * Clear the directory entry associated with a sub file.
 *
 * Input:
 *   - inode: directory inode
 *   - sub_name: sub file name
 *
 * Returns 0 if successful, -1 otherwise.

 * Possible errors:
 *   - inode is not a directory inode.
 *   - Directory does not contain an entry for sub_name.
 */
int clear_dir_entry(inode_t *inode, char const *sub_name) {
    my_w_lock(&lock_dir_table);
    insert_delay();
    if (inode->i_node_type != T_DIRECTORY) {
        my_unlock(&lock_dir_table);
        return -1; // not a directory
    }

    // Locates the block containing the entries of the directory
    dir_entry_t *dir_entry =
        (dir_entry_t *)data_block_get(inode->i_data_block);
    ALWAYS_ASSERT(dir_entry != NULL,
                  "clear_dir_entry: directory must have a data block");

    for (size_t i = 0; i < MAX_DIR_ENTRIES; i++) {
        if (!strcmp(dir_entry[i].d_name, sub_name)) {
            dir_entry[i].d_inumber = -1;
            memset(dir_entry[i].d_name, 0, MAX_FILE_NAME);
            my_unlock(&lock_dir_table);
            return 0;
        }
    }
    my_unlock(&lock_dir_table);
    return -1; // sub_name not found
}

/**
 * Store the inumber for a sub file in a directory.
 *
 * Input:
 *   - inode: directory inode
 *   - sub_name: sub file name
 *   - sub_inumber: inumber of the sub inode
 *
 * Returns 0 if successful, -1 otherwise.
 *
 * Possible errors:
 *   - inode is not a directory inode.
 *   - sub_name is not a valid file name (length 0 or > MAX_FILE_NAME - 1).
 *   - Directory is already full of entries.
 */
int add_dir_entry(inode_t *inode, char const *sub_name, int sub_inumber) {
    my_w_lock(&lock_dir_table);
    if (strlen(sub_name) == 0 || strlen(sub_name) > MAX_FILE_NAME - 1) {
        my_unlock(&lock_dir_table);
        return -1; // invalid sub_name
    }

    insert_delay(); // simulate storage access delay to inode with inumber
    if (inode->i_node_type != T_DIRECTORY) {
        my_unlock(&lock_dir_table);
        return -1; // not a directory
    }

    // Locates the block containing the entries of the directory
    dir_entry_t *dir_entry =
        (dir_entry_t *)data_block_get(inode->i_data_block);
    ALWAYS_ASSERT(dir_entry != NULL,
                  "add_dir_entry: directory must have a data block");

    // Finds and fills the first empty entry
    for (size_t i = 0; i < MAX_DIR_ENTRIES; i++) {
        if (dir_entry[i].d_inumber == -1) {
            dir_entry[i].d_inumber = sub_inumber;
            strncpy(dir_entry[i].d_name, sub_name, MAX_FILE_NAME - 1);
            dir_entry[i].d_name[MAX_FILE_NAME - 1] = '\0';
            my_unlock(&lock_dir_table);
            return 0;
        }
    }
    my_unlock(&lock_dir_table);
    return -1; // no space for entry
}

/**
 * Obtain the inumber for a sub file inside a directory.
 *
 * Input:
 *   - inode: directory inode
 *   - sub_name: sub file name
 *
 * Returns inumber linked to the target name, -1 if errors occur.
 *
 * Possible errors:
 *   - inode is not a directory inode.
 *   - Directory does not contain a file named sub_name.
 */
int find_in_dir(inode_t const *inode, char const *sub_name) {
    my_r_lock(&lock_dir_table);
    ALWAYS_ASSERT(inode != NULL, "find_in_dir: inode must be non-NULL");
    ALWAYS_ASSERT(sub_name != NULL, "find_in_dir: sub_name must be non-NULL");

    insert_delay(); // simulate storage access delay to inode with inumber
    if (inode->i_node_type != T_DIRECTORY) {
        my_unlock(&lock_dir_table);
        return -1; // not a directory
    }

    // Locates the block containing the entries of the directory
    dir_entry_t *dir_entry =
        (dir_entry_t *)data_block_get(inode->i_data_block);
    ALWAYS_ASSERT(dir_entry != NULL,
                  "find_in_dir: directory inode must have a data block");

    // Iterates over the directory entries looking for one that has the target
    // name
    for (int i = 0; i < MAX_DIR_ENTRIES; i++)
        if ((dir_entry[i].d_inumber != -1) &&
            (strncmp(dir_entry[i].d_name, sub_name, MAX_FILE_NAME) == 0)) {

            int sub_inumber = dir_entry[i].d_inumber;
            my_unlock(&lock_dir_table);
            return sub_inumber;
        }

    my_unlock(&lock_dir_table);
    return -1; // entry not found
}

/**
 * Allocate a new data block.
 *
 * Returns block number/index if successful, -1 otherwise.
 *
 * Possible errors:
 *   - No free data blocks.
 */
int data_block_alloc(void) {
    my_w_lock(&lock_data_table);
    for (size_t i = 0; i < DATA_BLOCKS; i++) {
        if (i * sizeof(allocation_state_t) % BLOCK_SIZE == 0) {
            insert_delay(); // simulate storage access delay to free_blocks
        }

        if (free_blocks[i] == FREE) {
            free_blocks[i] = TAKEN;
            my_unlock(&lock_data_table);
            return (int)i;
        }
    }

    my_unlock(&lock_data_table);
    return -1;
}

/**
 * Free a data block.
 *
 * Input:
 *   - block_number: the block number/index
 */
void data_block_free(int block_number) {
    my_w_lock(&lock_data_table);
    ALWAYS_ASSERT(valid_block_number(block_number),
                  "data_block_free: invalid block number");

    insert_delay(); // simulate storage access delay to free_blocks

    free_blocks[block_number] = FREE;
    my_unlock(&lock_data_table);
}

/**
 * Obtain a pointer to the contents of a given block.
 *
 * Input:
 *   - block_number: the block number/index
 *
 * Returns a pointer to the first byte of the block.
 */
void *data_block_get(int block_number) {
    my_r_lock(&lock_data_table);
    ALWAYS_ASSERT(valid_block_number(block_number),
                  "data_block_get: invalid block number");

    insert_delay(); // simulate storage access delay to block
    my_unlock(&lock_data_table);
    return &fs_data[(size_t)block_number * BLOCK_SIZE];
}

/**
 * Add a new entry to the open file table.
 *
 * Input:
 *   - inumber: inode number of the file to open
 *   - offset: initial offset
 *
 * Returns file handle if successful, -1 otherwise.
 *
 * Possible errors:
 *   - No space in open file table for a new open file.
 */
int add_to_open_file_table(int inumber, size_t offset) {
    my_w_lock(&lock_file_table);
    for (int i = 0; i < MAX_OPEN_FILES; i++) {
        if (free_open_file_entries[i] == FREE) {
            free_open_file_entries[i] = TAKEN;
            open_file_table[i].of_inumber = inumber;
            open_file_table[i].of_offset = offset;
            my_unlock(&lock_file_table);
            return i;
        }
    }

    my_unlock(&lock_file_table);
    return -1;
}

/**
 * Free an entry from the open file table.
 *
 * Input:
 *   - fhandle: file handle to free/close
 */
void remove_from_open_file_table(int fhandle) {
    my_w_lock(&lock_file_table);
    ALWAYS_ASSERT(valid_file_handle(fhandle),
                  "remove_from_open_file_table: file handle must be valid");

    ALWAYS_ASSERT(free_open_file_entries[fhandle] == TAKEN,
                  "remove_from_open_file_table: file handle must be taken");

    free_open_file_entries[fhandle] = FREE;
    my_unlock(&lock_file_table);
}

/**
 * Obtain pointer to a given entry in the open file table.
 *
 * Input:
 *   - fhandle: file handle
 *
 * Returns pointer to the entry, or NULL if the fhandle is
 * invalid/closed/never opened.
 */
open_file_entry_t *get_open_file_entry(int fhandle) {
    my_r_lock(&lock_file_table);
    if (!valid_file_handle(fhandle)) {
        my_unlock(&lock_file_table);
        return NULL;
    }

    if (free_open_file_entries[fhandle] != TAKEN) {
        my_unlock(&lock_file_table);
        return NULL;
    }
    my_unlock(&lock_file_table);
    return &open_file_table[fhandle];
}

/**
 * @brief Obtains a pointer to a lock from its file handler
 *
 * @param fhandle file handle
 * @return pointer to the lock
 */
pthread_rwlock_t *get_open_file_lock(int fhandle) {
    return &lock_file[fhandle];
}

/**
 * @brief Gets the inumber to the original file in a symlink chain
 *
 * @param inumber inumber of the first sym link in the chain
 * @return inumber
 */
int get_path_recursive(int inumber) {
    if (inumber == -1) {
        return -1;
    }
    inode_t *inode = inode_get(inumber);
    if (inode->i_node_type != T_SOFT_LINK) {
        return inumber;
    }
    char *block = data_block_get(inode->i_data_block);
    inode_t *root = inode_get(ROOT_DIR_INUM);
    int inum = find_in_dir(root, ++block);
    return get_path_recursive(inum);
}

/**
 * @brief Checks for read locks errors
 *
 * @param lock read lock
 */
void my_r_lock(pthread_rwlock_t *lock) {
    if (pthread_rwlock_rdlock(lock) != 0) {
        exit(1);
    }
}

/**
 * @brief Checks for write locks errors
 *
 * @param lock write lock
 */
void my_w_lock(pthread_rwlock_t *lock) {
    if (pthread_rwlock_wrlock(lock) != 0) {
        exit(1);
    }
}

/**
 * @brief Checks for unlock errors
 *
 * @param lock write/read lock to unlock
 */
void my_unlock(pthread_rwlock_t *lock) {
    if (pthread_rwlock_unlock(lock) != 0) {
        exit(1);
    }
}