#include "fs/operations.h"
#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/* This tests evaluates the capability of TFS to copy a non-existent
 * file and see if the information that it had wasn't been corrupted. */

int main() {
  char *path_copied_file = "/phi.txt";
  char *path_copied_file1 = "/phii.txt";
  char *path_src_file = "tests/bigger.txt";
  char *fake_src_file = "tests/biggerOrNot.txt";
  char *expected_file_reading = "xxxxx";
  char reading_buffer[5];
  char reading_buffer1[5];
  int f, f1;
  ssize_t r, r1;
  
  // Initiate Técnico Filesystem
  assert(tfs_init(NULL) != -1);

  // Copy external file to Técnico Filesystem
  assert(tfs_copy_from_external_fs(path_src_file, path_copied_file) != -1);

  // Open copied file in Técnico Filesystem
  f = tfs_open(path_copied_file, 0b0);
  assert(f != -1);

  // Read information in copied file from Técnico Filesystem
  r = tfs_read(f, reading_buffer, sizeof(reading_buffer));
  assert(r == strlen(expected_file_reading));
  assert(memcmp(reading_buffer, expected_file_reading, strlen(expected_file_reading)) == 0);

  // Close open file
  assert(tfs_close(f) != -1);

  // Try to copy a file that doesn't exist 
  f = tfs_copy_from_external_fs(fake_src_file, path_copied_file);
  assert(f == -1);

  // Verify that the file wasn't been corrupted
  f = tfs_open(path_copied_file, 0b0);
  assert(f != -1);
  memset(reading_buffer, 0, strlen(reading_buffer));
  r = tfs_read(f, reading_buffer, sizeof(reading_buffer));
  assert(r == strlen(expected_file_reading));
  assert(memcmp(reading_buffer, expected_file_reading, strlen(expected_file_reading)) == 0);
  
  // Copy exact file with different name
  assert(tfs_copy_from_external_fs(path_src_file, path_copied_file1) != -1);
  
  // Check if the files have the same content
  f1 = tfs_open(path_copied_file1, 0b0);
  assert(f1 != -1);
  r1 = tfs_read(f1, reading_buffer1, sizeof(reading_buffer1));
  assert(r1 == strlen(expected_file_reading));
  assert(memcmp(reading_buffer1, expected_file_reading, strlen(expected_file_reading)) == 0);
  assert(memcmp(reading_buffer, expected_file_reading, strlen(expected_file_reading)) == 0);
  //assert(strcmp(reading_buffer, reading_buffer1) == 0);
  assert(tfs_close(f1) != -1);
  assert(tfs_close(f) != -1);
  

  printf("Successful test.\n");
  return 0;
}
