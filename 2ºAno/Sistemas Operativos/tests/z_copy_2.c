#include "fs/operations.h"
#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/* This test evaluates the capability of TFS to copy a file that
 * would re-write the contents of an existing file and evaluate it's
 * behaviour. */

int main() {
  char *path_copied_file = "/phi.txt";
  char *path_src_file = "tests/bigger.txt";
  char *path_src_file1 = "tests/smaller.txt";
  char *expected_file_reading_bigger = "xxxxx";
  char *expected_file_reading_smaller = "yyyyy";
  char reading_buffer[5];
  char reading_buffer1[5];
  int f, f1;
  ssize_t r, r1;
  
  // Initiate Técnico Filesystem
  assert(tfs_init(NULL) != -1);

  // Copy external file to Técnico Filesystem
  assert(tfs_copy_from_external_fs(path_src_file, path_copied_file) != -1);

  // Copy different file but with the same name
  assert(tfs_copy_from_external_fs(path_src_file1, path_copied_file) != -1);

  // Open copied file, read it and keep it opened
  f = tfs_open(path_copied_file, 0b0);
  assert(f != -1);
  r = tfs_read(f, reading_buffer, sizeof(reading_buffer));
  assert(r == strlen(expected_file_reading_smaller));
  assert(memcmp(reading_buffer, expected_file_reading_smaller, strlen(expected_file_reading_smaller)) == 0);
  memset(reading_buffer, 0, strlen(reading_buffer));

  // Copy different file but with the same name
  assert(tfs_copy_from_external_fs(path_src_file, path_copied_file) != -1);
  f1 = tfs_open(path_copied_file, 0b0);
  assert(f != -1);
  r1 = tfs_read(f1, reading_buffer1, sizeof(reading_buffer1));
  assert(r1 == strlen(expected_file_reading_bigger));
  assert(memcmp(reading_buffer1, expected_file_reading_bigger, strlen(expected_file_reading_bigger)) == 0);
  
  // Check if the first open file table entry has been updated
  r = tfs_read(f, reading_buffer, sizeof(reading_buffer));
  assert(r == strlen(expected_file_reading_bigger));
  assert(memcmp(reading_buffer, expected_file_reading_bigger, strlen(expected_file_reading_bigger)) == 0);

  printf("Successful test.\n");
  return 0;
}
