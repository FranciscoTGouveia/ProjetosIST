#include "fs/operations.h"
#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <pthread.h>

/* This test evaluates the capacity of TFS to handle multi-threading */


uint8_t const file_contents[] = "threads";
char *target_path1 = "/ficheiro1";
char *target_path2 = "/ficheiro2";
char *target_path3 = "/ficheiro3";
char *target_path4 = "/ficheiro4";
char *link_path1 = "/link1";
char *link_path2 = "/link2";
char *link_path3 = "/link3";
char *link_path4 = "/link4";
char *link_path5 = "/link5";


void create_new_file(char *path) {
  int fileDescriptor = tfs_open(path, TFS_O_CREAT);
  assert(fileDescriptor != -1);
  assert(tfs_close(fileDescriptor) != -1);
}

void assert_contents_ok(char *path) {
    int f = tfs_open(path, 0);
    assert(f != -1);
    char buffer[sizeof(file_contents)];
    assert(tfs_read(f, buffer, strlen(buffer)) == strlen(buffer));
    assert(memcmp(buffer, file_contents, strlen(buffer)) == 0);
    assert(tfs_close(f) != -1);
}

void write_contents(char *path) {
    int f = tfs_open(path, TFS_O_APPEND);
    assert(f != -1);
    assert(tfs_write(f, file_contents, sizeof(file_contents)) == sizeof(file_contents));
    assert(tfs_close(f) != -1);
}

void *thread_function_1() {
  assert(tfs_link(target_path1, link_path1) != -1);
  write_contents(link_path1);
  assert(tfs_unlink(target_path1) != -1);
  assert(tfs_unlink(target_path1) == -1);
  return 0;
}

void *thread_function_2() {
  assert(tfs_link(target_path2, link_path2) != -1);
  write_contents(link_path2);
  assert_contents_ok(link_path2);
  assert(tfs_sym_link(target_path2, link_path3) != -1);
  return 0;
}

void *thread_function_3() {
  assert(tfs_sym_link(target_path3, link_path3) != -1);
  write_contents(target_path3);
  assert_contents_ok(target_path3);
  return 0;
}

void *thread_function_4() {
  write_contents(target_path4);
  assert(tfs_link(target_path4, link_path4) != -1);
  assert(tfs_unlink(target_path4) != -1);
  assert(tfs_sym_link(link_path4, link_path5) != -1);
  assert_contents_ok(link_path5);
  return 0;
}




int main() {
  // Initiate Técnico Filesystem
  assert(tfs_init(NULL) != -1);
  
  // Create five files
  create_new_file(target_path1);
  create_new_file(target_path2);
  create_new_file(target_path3);
  create_new_file(target_path4);

  // Create 3 threads, and join them
  pthread_t thread_1, thread_2, thread_3, thread_4;
  assert(pthread_create(&thread_1, NULL, thread_function_1, NULL) == 0);
  assert(pthread_create(&thread_2, NULL, thread_function_2, NULL) == 0);
  assert(pthread_join(thread_1, NULL) == 0);
  assert(pthread_join(thread_2, NULL) == 0);
  assert(pthread_create(&thread_3, NULL, thread_function_3, NULL) == 0);
  assert(pthread_create(&thread_4, NULL, thread_function_4, NULL) == 0);
  assert(pthread_join(thread_3, NULL) == 0);
  assert(pthread_join(thread_4, NULL) == 0);
  
  printf("Successful test.\n");
  return 0;
}
