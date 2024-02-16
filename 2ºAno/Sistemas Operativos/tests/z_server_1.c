#include "fs/operations.h"
#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/* This tests evaluates the capability of TFS to copy a non-existent
 * file and see if the information that it had wasn't been corrupted. */

int main() {
  char my_filename[] = "/jujuka.txt";
  char message1[] = "jujuka";
  char message2[] = "thais";

  // Initiate Técnico Filesystem
  assert(tfs_init(NULL) != -1);

  // Create file and write two different sentences and close it
  int fd = tfs_open(my_filename, TFS_O_CREAT);
  assert(fd != -1);
  assert(tfs_write(fd, message1, sizeof(message1)) == sizeof(message1));
  assert(tfs_write(fd, message2, sizeof(message2)) == sizeof(message2));
  assert(tfs_close(fd) != -1);  

  // Open file again and read it's contents
  fd = tfs_open(my_filename, 0b0);
  assert(fd != -1);
  uint8_t buffer1[sizeof(message1)];
  assert(tfs_read(fd, buffer1, sizeof(buffer1)) == sizeof(buffer1));
  uint8_t buffer2[sizeof(message2)];
  assert(tfs_read(fd, buffer2, sizeof(buffer2)) == sizeof(buffer2));
  assert(tfs_close(fd) != -1);
  printf("first line: %s\n", buffer1);
  printf("second line: %s\n", buffer2);

  printf("Successful test.\n");
  return 0;
}
