#include "fs/operations.h"
#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/* This test evaluates the capability of TFS to create two
 * distinct hardlinks and softlinks, write through one of them
   and read through the other */


uint8_t const file_contents[] = "links";
char const *target_path1 = "/ficheiro1";
char const *target_path2 = "/ficheiro2";
char const *link_path1 = "/link1";
char const *link_path2 = "/link2";
char const *link_path3 = "/link3";
char const *link_path4 = "/link4";

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
  
  // Create a new file
  int f = tfs_open(target_path1, TFS_O_CREAT);
  assert(f != -1);
  assert(tfs_close(f) != -1);

  // Create two hardlinks, write through one, read through the other
  assert(tfs_link(target_path1, link_path1) != -1);
  assert(tfs_link(target_path1, link_path2) != -1);
  write_contents(link_path1);
  assert_contents_ok(link_path2);
    
  // Create a new file
  int f1 = tfs_open(target_path2, TFS_O_CREAT);
  assert(f1 != -1);
  assert(tfs_close(f1) != -1);

  // Create two softlinks, write through one, read through the other
  assert(tfs_sym_link(target_path2, link_path3) != -1);
  assert(tfs_sym_link(target_path2, link_path4) != -1);
  write_contents(link_path3);
  assert_contents_ok(link_path4);

  printf("Successful test.\n");
  return 0;
}
