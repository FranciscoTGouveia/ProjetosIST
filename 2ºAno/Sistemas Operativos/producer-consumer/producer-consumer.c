#include "producer-consumer.h"
#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "../utils/task.h"
#include "../utils/pipeflow.h"
#include "../utils/safety_mechanisms.h"

int pcq_create(pc_queue_t *queue, size_t capacity) {
    queue->pcq_capacity = capacity;
    queue->pcq_buffer = my_malloc(sizeof(task) * capacity);
    my_mutex_init(&queue->pcq_current_size_lock, NULL);
    my_mutex_init(&queue->pcq_head_lock, NULL);
    my_mutex_init(&queue->pcq_tail_lock, NULL);
    my_mutex_init(&queue->pcq_pusher_condvar_lock, NULL);
    my_mutex_init(&queue->pcq_popper_condvar_lock, NULL);
    my_cond_init(&queue->pcq_pusher_condvar, NULL);
    my_cond_init(&queue->pcq_popper_condvar, NULL);
    return 0;
}

// Check other fucntions
int pcq_destroy(pc_queue_t *queue) {
    my_mutex_destroy(&queue->pcq_current_size_lock);
    my_mutex_destroy(&queue->pcq_head_lock);
    my_mutex_destroy(&queue->pcq_tail_lock);
    my_mutex_destroy(&queue->pcq_pusher_condvar_lock);
    my_mutex_destroy(&queue->pcq_popper_condvar_lock);
    my_cond_destroy(&queue->pcq_pusher_condvar);
    my_cond_destroy(&queue->pcq_popper_condvar);
    for (size_t i = queue->pcq_head; i <= queue->pcq_tail; i++) {
        free(((task *)queue->pcq_buffer[i])->request);
        free(queue->pcq_buffer[i]);
    }
    free(queue->pcq_buffer);
    return 0;
}

int pcq_enqueue(pc_queue_t *queue, void *elem) {
    my_mutex_lock(&queue->pcq_pusher_condvar_lock);
    while (queue->pcq_current_size == queue->pcq_capacity) {
        my_cond_wait(&queue->pcq_pusher_condvar,
                     &queue->pcq_pusher_condvar_lock);
    }
    my_mutex_lock(&queue->pcq_current_size_lock);
    my_mutex_lock(&queue->pcq_head_lock);
    if (queue->pcq_current_size != 0) {
        for (size_t i = queue->pcq_tail + 1; i > queue->pcq_head; i--) {
            queue->pcq_buffer[i] = queue->pcq_buffer[i - 1];
        }
    }
    queue->pcq_buffer[queue->pcq_head] = elem;
    if (queue->pcq_current_size != 0) {
        queue->pcq_tail++;
    }
    queue->pcq_current_size++;
    my_mutex_unlock(&queue->pcq_head_lock);
    my_mutex_unlock(&queue->pcq_current_size_lock);
    my_mutex_unlock(&queue->pcq_pusher_condvar_lock);
    my_cond_signal(&queue->pcq_popper_condvar);
    return 0;
}

void *pcq_dequeue(pc_queue_t *queue) {
    my_mutex_lock(&queue->pcq_popper_condvar_lock);
    while (queue->pcq_current_size == 0) {
        my_cond_wait(&queue->pcq_popper_condvar,
                     &queue->pcq_popper_condvar_lock);
    }
    my_mutex_lock(&queue->pcq_current_size_lock);
    my_mutex_lock(&queue->pcq_tail_lock);
    task *removed_task = (task *)queue->pcq_buffer[queue->pcq_tail];
    if (queue->pcq_tail != queue->pcq_head) {
        queue->pcq_tail--;
    }
    queue->pcq_current_size--;
    my_mutex_unlock(&queue->pcq_tail_lock);
    my_mutex_unlock(&queue->pcq_current_size_lock);
    my_mutex_unlock(&queue->pcq_popper_condvar_lock);
    my_cond_signal(&queue->pcq_pusher_condvar);
    return removed_task;
}