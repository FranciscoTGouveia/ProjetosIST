#include "fs/operations.h"
#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/* This test evaluates the capability of TFS to clean the open
   file table, and assign correctly a new file descriptor */

int main() {
  char *path_copied_file = "/phi.txt";
  char *path_copied_file1 = "/phii.txt";
  char *path_src_file = "tests/bigger.txt";
  char *path_src_file1 = "tests/smaller.txt";
  int f, f1;
  
  // Initiate Técnico Filesystem
  assert(tfs_init(NULL) != -1);
  
  // Copy external files to Técnico Filesystem
  assert(tfs_copy_from_external_fs(path_src_file, path_copied_file) != -1);
  assert(tfs_copy_from_external_fs(path_src_file1, path_copied_file1) != -1);

  // Open copied files
  f = tfs_open(path_copied_file, 0b0);
  assert(f != -1);
  assert(tfs_open(path_copied_file1, 0b0) != -1);
  assert(tfs_close(f) != -1);
  
  // Copy second external file to the first file in TFS
  assert(tfs_copy_from_external_fs(path_src_file1, path_copied_file) != -1);
  f1 = tfs_open(path_copied_file, 0b0);
  assert(f1 != -1);
  assert(f1 == f);

  printf("Successful test.\n");
  return 0;
}
