#include "fs/operations.h"
#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/* This test evaluates the capability of TFS unlink
   open files */ 


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
  
  // Create new file and leave it open
  int fd;
  assert(fd = (tfs_open(target_path1, TFS_O_CREAT)) != -1);
  
  // Try to delete open file and expect error
  tfs_unlink(target_path1);
  assert(tfs_write(fd,file_contents,sizeof(file_contents)) == -1);


  printf("Successful test.\n");
  return 0;
}
