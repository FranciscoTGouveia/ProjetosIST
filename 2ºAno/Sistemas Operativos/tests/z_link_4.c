#include "fs/operations.h"
#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/* This test evaluates the capability of TFS to create links
   to files that doesn't exist */ 


uint8_t const file_contents[] = "links";
char const *target_path1 = "/ficheiro1";
char const *target_path2 = "/ficheiro2";
char const *link_path1 = "/link1";
char const *link_path2 = "/link2";

void assert_contents_ok(char const *path) {
    int f = tfs_open(path, 0);
    assert(f != -1);

    uint8_t buffer[sizeof(file_contents)];
    assert(tfs_read(f, buffer, sizeof(buffer)) == sizeof(buffer));
    assert(memcmp(buffer, file_contents, sizeof(buffer)) == 0);

    assert(tfs_close(f) != -1);
}

void write_contents(char const *path) {
    int f = tfs_open(path, TFS_O_APPEND);
    assert(f != -1);

    assert(tfs_write(f, file_contents, sizeof(file_contents)) ==
           sizeof(file_contents));

    assert(tfs_close(f) != -1);
}

int main() {
  // Initiate Técnico Filesystem
  assert(tfs_init(NULL) != -1);
  
  // Create soft link to non-existent file
  assert(tfs_sym_link(target_path1, link_path1) == -1);
  
  // Create hard link to non-existent file
  assert(tfs_link(target_path2, link_path2) == -1);
    
  // Assure that the links are working properly
  assert(tfs_open(link_path1, 0b0) == -1);
  assert(tfs_open(link_path2, 0b0) == -1);;
  
  // Create the file that the softlink points to
  assert(tfs_open(target_path1, TFS_O_CREAT) != -1);
  assert(tfs_open(link_path1, 0b0) == -1);
  
  // Create the file that the hardlink points to
  assert(tfs_open(target_path2, TFS_O_CREAT) != -1);
  assert(tfs_open(link_path2, 0b0) == -1);

  printf("Successful test.\n");
  return 0;
}
