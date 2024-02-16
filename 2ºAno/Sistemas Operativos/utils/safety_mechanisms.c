#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>

void *my_malloc(size_t size) {
    void *ptr = malloc(size);
    if (!ptr) {
        printf("Falha na alocação de memória.\n");
        // codigo para limpar todas as merdas
        exit(1);
    }
    return ptr;
}

int my_open(char *pathname, int mode) {
    int fd = open(pathname, mode);
    if (fd < 0) exit(1);
    return fd;
}

void my_close(int fd) {
    if (close(fd) == -1) exit(1);
}

void my_unlink(char *pathname) {
    if (unlink(pathname) == -1) exit(1);
}

void my_mkfifo(char *pathname, mode_t mode) {
    if (mkfifo(pathname, mode) < 0) exit(1);
}

void my_write(int fd, char *buffer, size_t count) {
    if (write(fd, buffer, count) < 0) exit(1);
}

void my_read(int fd, char *buffer, size_t count) {
    if (read(fd, buffer, count) < 0) exit(1);
}

void my_mutex_init(pthread_mutex_t *mutex, pthread_mutexattr_t *attr) {
    if (pthread_mutex_init(mutex, attr) == -1) exit(1);
}

void my_mutex_lock(pthread_mutex_t *mutex) {
    if (pthread_mutex_lock(mutex) == -1) exit(1);
}

void my_mutex_unlock(pthread_mutex_t *mutex) {
    if (pthread_mutex_unlock(mutex) == -1) exit(1);
}

void my_mutex_destroy(pthread_mutex_t *mutex) {
    if (pthread_mutex_destroy(mutex) == -1) exit(1);
}

void my_cond_init(pthread_cond_t *cond, pthread_condattr_t *attr) {
    if (pthread_cond_init(cond, attr) == -1) exit(1);
}

void my_cond_signal(pthread_cond_t *cond) {
    if (pthread_cond_signal(cond) == -1) exit(1);
}

void my_cond_wait(pthread_cond_t *cond, pthread_mutex_t *mutex) {
    if (pthread_cond_wait(cond, mutex) == -1) exit(1);
}

void my_cond_destroy(pthread_cond_t *cond) {
    if (pthread_cond_destroy(cond) == -1) exit(1);
}