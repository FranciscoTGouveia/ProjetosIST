#define __UTILS_SERVER_STRCUTURES__

#include <sys/types.h>

void *my_malloc(size_t size);
int my_open(char *pathname, int mode);
void my_close(int fd);
void my_unlink(char *pathname);
void my_mkfifo(char *pathname, mode_t mode);
void my_write(int fd, char *buffer, size_t count);
void my_read(int fd, char *buffer, size_t count);
void my_mutex_init(pthread_mutex_t *mutex, pthread_mutexattr_t *attr);
void my_mutex_lock(pthread_mutex_t *mutex);
void my_mutex_unlock(pthread_mutex_t *mutex);
void my_mutex_destroy(pthread_mutex_t *mutex);
void my_cond_init(pthread_cond_t *cond, pthread_condattr_t *attr);
void my_cond_signal(pthread_cond_t *cond);
void my_cond_wait(pthread_cond_t *cond, pthread_mutex_t *mutex);
void my_cond_destroy(pthread_cond_t *cond);