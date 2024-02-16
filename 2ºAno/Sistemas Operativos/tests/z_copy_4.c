#include "fs/operations.h"
#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/* This test evaluates the capability of TFS to copy and external file
   that has a size bigger than the size block */

int main() {
  char *path_copied_file = "/phi.txt";
  char *path_src_file = "tests/bigger_than_1024.txt";
  
  // Initiate Técnico Filesystem
  assert(tfs_init(NULL) != -1);
  
  // Copy external files to Técnico Filesystem
  assert(tfs_copy_from_external_fs(path_src_file, path_copied_file) == -1);
  assert(tfs_open(path_copied_file, 0b0) != -1);

  printf("Successful test.\n");
  return 0;
}
