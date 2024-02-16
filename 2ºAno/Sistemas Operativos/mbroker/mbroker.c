#include "../utils/logging.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>
#include "../utils/task.h"
#include "../utils/reader_stc.h"
#include "../utils/writer_stc.h"
#include "../utils/pipeflow.h"
#include "../utils/server_structures.h"
#include "../utils/safety_mechanisms.h"
#include "../producer-consumer/producer-consumer.h"
#include <unistd.h>
#include "../fs/operations.h"
#include <errno.h>
#include <signal.h>
#define END 1
#define ON_GOING 0

pc_queue_t *task_queue;
char *server_pipe;
pthread_mutex_t thread_lock;
pthread_cond_t thread_cond;
box *server_boxes;
int size_boxes;
pthread_mutex_t box_size_lock;
thread *thread_pool;
int status = ON_GOING;

void ignore_signal(int s) {
    (void)s;
    signal(SIGPIPE, ignore_signal);
}

void end_program_ctrlC(int s) {
    my_write(1, "O PROGRAMA IRÁ ENCERRAR ASSIM QUE POSSÍVEL\n",
             strlen("O PROGRAMA IRÁ ENCERRAR ASSIM QUE POSSÍVEL\n"));
    status = END;
    tfs_destroy();
    free(task_queue);
    free(thread_pool);
    free(server_boxes);
    my_unlink(server_pipe);
    printf("O PROGRAMA ENCERROU\n");
    exit(0);
    (void)s;
}

void process_sub(void *arg, int *index) {
    signal(SIGINT, end_program_ctrlC);
    my_mutex_lock(&box_size_lock);
    int tester = 0;
    for (int i = 0; i < size_boxes; i++) {
        if (strcmp(((request*)arg)->box_name, server_boxes[i].box_name) == 0) {
            if (strcmp(server_boxes[i].box_password, ((request*)arg)->box_password) != 0) break;
            tester = 1;
            thread_pool[*index].index = i;
            server_boxes[i].n_subs += 1;
            break;
        }
    }
    my_mutex_unlock(&box_size_lock);
    if (tester == 0) {
        int fd = my_open(((request *)arg)->pipe_name, O_WRONLY);
        my_close(fd);
        return;
    }
    int fd_tfs = tfs_open(((request *)arg)->box_name, 0);
    if (fd_tfs == -1) exit(1);
    signal(SIGPIPE, ignore_signal);
    int fd = my_open(((request *)arg)->pipe_name, O_WRONLY);
    while (1) {
        my_mutex_lock(&server_boxes[thread_pool[*index].index].box_lock);
        messages_pipe newmessage;
        newmessage.code = 10;
        char teste[1024];
        ssize_t value;
        while ((value = tfs_read(fd_tfs, teste, sizeof(teste))) == 0) {
            my_cond_wait(&server_boxes[thread_pool[*index].index].cond_var,
                         &server_boxes[thread_pool[*index].index].box_lock);
        }
        if (status == END) {
            my_mutex_unlock(
                &server_boxes[thread_pool[*index].index].box_lock);
            my_close(fd);
            tfs_close(fd_tfs);
            return;
        }
        if (value == -1) {
            server_boxes[thread_pool[*index].index].n_subs -= 1;
            my_close(fd);
            tfs_close(fd_tfs);
            my_mutex_unlock(
                &server_boxes[thread_pool[*index].index].box_lock);
            return;
        }
        while (value > 0) {
            strcpy(newmessage.message, teste);
            char pipe_message[MAX_LINE];
            writer_stc(&newmessage, 10, pipe_message);
            ssize_t bytes = write(fd, pipe_message, sizeof(pipe_message));
            if (bytes == -1) {
                if (errno == EPIPE) {
                    server_boxes[thread_pool[*index].index].n_subs -= 1;
                    tfs_close(fd_tfs);
                    my_mutex_unlock(
                        &server_boxes[thread_pool[*index].index].box_lock);
                    return;
                }
            }
            memset(teste, 0, sizeof(teste));
            memset(newmessage.message, 0, (sizeof(char) * 1024));
            value = tfs_read(fd_tfs, teste, sizeof(teste));
            if (value == -1) {
                server_boxes[thread_pool[*index].index].n_subs -= 1;
                my_close(fd);
                tfs_close(fd_tfs);
                my_mutex_unlock(
                    &server_boxes[thread_pool[*index].index].box_lock);
                return;
            }
        }
        my_mutex_unlock(&server_boxes[thread_pool[*index].index].box_lock);
    }
    my_close(fd);
    tfs_close(fd_tfs);
    server_boxes[thread_pool[*index].index].n_subs -= 1;
    return;
}

void process_pub(void *arg, int *index) {
    signal(SIGINT, end_program_ctrlC);
    my_mutex_lock(&box_size_lock);
    int tester = 0;
    for (int i = 0; i < size_boxes; i++) {
        if (strcmp(((request *)arg)->box_name, server_boxes[i].box_name) ==
            0) {
            if (server_boxes[i].n_pub == 1) {
                my_mutex_unlock(&box_size_lock);
                int fd = my_open(((request *)arg)->pipe_name, O_RDONLY);
                close(fd);
                return;
            }
            if (strcmp(server_boxes[i].box_password, ((request*)arg)->box_password) != 0) break;
            tester = 1;
            thread_pool[*index].index = i;
            server_boxes[i].n_pub = 1;
            server_boxes[i].box_size = 0;
            break;
        }
    }
    if (tester == 0) {
        int fd = my_open(((request *)arg)->pipe_name, O_RDONLY);
        my_close(fd);
        my_mutex_unlock(&box_size_lock);
        return;
    }
    my_mutex_unlock(&box_size_lock);
    signal(SIGPIPE, ignore_signal);
    int fd = my_open(((request *)arg)->pipe_name, O_RDONLY);
    int fd_tfs = tfs_open(((request *)arg)->box_name, TFS_O_APPEND);
    if (fd_tfs == -1) {
        my_close(fd);
        return;
    }
    while (1) {
        if (status == END) {
            my_close(fd);
            tfs_close(fd_tfs);
            return;
        }
        char buffer[MAX_LINE];
        ssize_t bytes = read(fd, buffer, sizeof(buffer));
        if (bytes == 0) {
            break;
        }
        if (bytes > 0) {
            uint8_t teste;
            memcpy(&teste, buffer, sizeof(teste));
            messages_pipe *pipe_message = reader_stc(buffer);
            ssize_t bytes_tfs = tfs_write(fd_tfs, pipe_message->message,
                                          strlen(pipe_message->message) + 1);
            if (bytes_tfs == -1) {
                free(pipe_message);
                break;
            }
            server_boxes[thread_pool[*index].index].box_size +=
                (int)strlen(pipe_message->message);
            if (pthread_cond_broadcast(
                    &server_boxes[thread_pool[*index].index].cond_var) == -1)
                exit(1);
            free(pipe_message);
        }
    }
    tfs_close(fd_tfs);
    my_close(fd);
    server_boxes[thread_pool[*index].index].n_pub = 0;
    return;
}

void process_manager_list(void *arg, int *index) {
    signal(SIGINT, end_program_ctrlC);
    (void)index;
    my_mutex_lock(&box_size_lock);
    int counter = 0;
    list_manager_response boxes_to_send[size_boxes];
    for (int i = 0; i < size_boxes; i++) {
        if (server_boxes[i].free == 1) {
            boxes_to_send[counter].code = 8;
            boxes_to_send[counter].last = 0;
            strcpy(boxes_to_send[counter].box_name, server_boxes[i].box_name);
            boxes_to_send[counter].box_size = (uint64_t)server_boxes[i].box_size; // need to calculate the size 
            boxes_to_send[counter].n_pubs = (unsigned int)server_boxes[i].n_pub;
            boxes_to_send[counter].n_subs = (unsigned int)server_boxes[i].n_subs;
            strcpy(boxes_to_send[counter].box_password, server_boxes[i].box_password);
            counter++;
        }
    }
    my_mutex_unlock(&box_size_lock);
    if (counter == 0) {
        boxes_to_send[counter].code = 8;
        memset(boxes_to_send[counter].box_name, 0, MAX_BOX_NAME);
        counter++;
    }
    boxes_to_send[counter - 1].last = 1;
    signal(SIGPIPE, ignore_signal);
    int fd = open(((list_manager_request *)arg)->pipe_name, O_WRONLY);
    if (fd < 0) {
        return;
    }
    for (int i = 0; i < counter; i++) {
        char buffer[MAX_LINE];
        writer_stc(&boxes_to_send[i], boxes_to_send[i].code, buffer);
        ssize_t value = write(fd, buffer, sizeof(buffer));
        if (value == -1) {
            if (errno == EPIPE) {
                break;
            }
        }
    }
    my_close(fd);
}

void process_manager_remove(void *arg, int *index) {
    signal(SIGINT, end_program_ctrlC);
    my_mutex_lock(&box_size_lock);
    int tester = 0;
    for (int i = 0; i < size_boxes; i++) {
        if (strcmp(((request *)arg)->box_name, server_boxes[i].box_name) ==
            0) {
            if (server_boxes[i].free == 0) {
                my_mutex_unlock(&box_size_lock);
                return;
            }
            if (strcmp(server_boxes[i].box_password,((request*)arg)->box_password) != 0) {
                my_mutex_unlock(&box_size_lock);
                response_manager response;
                response.code = 6;
                response.return_code = -1;
                strcpy(response.error_message, "Ocorreu um erro palavra-passe errada");
                char buffer_error[MAX_LINE];
                writer_stc(&response, response.code, buffer_error);
                int fd = open(((request*)arg)->pipe_name, O_WRONLY);
                if (fd < 0) exit(-1);
                ssize_t value = write(fd, buffer_error, sizeof(buffer_error));
                if (value == -1) {
                    if (errno == EPIPE) exit(-1);
                }
                return;
            }
            thread_pool[*index].index = i;
            tester = 1;
            break;
        }
    }
    response_manager response;
    response.code = 6;
    tester = tfs_unlink(((request *)arg)->box_name);
    if (tester == -1) {
        response.return_code = -1;
        strcpy(response.error_message, "Ocorreu um erro ao eliminar a caixa");
    } else {
        response.return_code = 0;
        memset(response.error_message, 0, 1024);
        server_boxes[thread_pool[*index].index].free = 0;
        server_boxes[thread_pool[*index].index].n_pub = 0;
        server_boxes[thread_pool[*index].index].n_subs = 0;
        server_boxes[thread_pool[*index].index].box_size = 0;
        memset(server_boxes[thread_pool[*index].index].box_name, 0, MAX_BOX_NAME);
        memset(server_boxes[thread_pool[*index].index].box_password, 0, MAX_PASSWORD);
    }
    char buffer[MAX_LINE];
    writer_stc(&response, response.code, buffer);
    signal(SIGPIPE, ignore_signal);
    int fd = open(((request *)arg)->pipe_name, O_WRONLY);
    if (fd < 0) {
        pthread_mutex_unlock(&box_size_lock);
        return;
    }
    ssize_t value = write(fd, buffer, sizeof(buffer));
    if (value == -1) {
        if (errno == EPIPE) {
            pthread_mutex_unlock(&box_size_lock);
            return;
        }
    }
    my_mutex_unlock(&box_size_lock);
    my_close(fd);
    if (pthread_cond_broadcast(
            &server_boxes[thread_pool[*index].index].cond_var) == -1)
        exit(1);
}

void process_manager_create(void *arg, int *index) {
    my_mutex_lock(&box_size_lock);
    int tester = 0;
    for (int i = 0; i < size_boxes; i++) {
        if (strcmp(((request *)arg)->box_name, server_boxes[i].box_name) ==
            0) {
            signal(SIGPIPE, ignore_signal);
            int fd = my_open(((request *)arg)->pipe_name, O_WRONLY);
            response_manager response;
            response.code = 4;
            response.return_code = -1;
            strcpy(response.error_message,
                   "Ocorreu um erro na criação da caixa");
            my_mutex_unlock(&box_size_lock);
            char buffer[MAX_LINE];
            writer_stc(&response, response.code, buffer);
            ssize_t bytes = write(fd, buffer, sizeof(buffer));
            if (bytes == -1) {
                if (errno == EPIPE) {
                    return;
                }
            }
            my_close(fd);
            return;
        }
    }
    for (int i = 0; i < size_boxes; i++) {
        if (server_boxes[i].free == 0) {
            tester = 1;
            thread_pool[*index].index = i;
            server_boxes[i].free = 1;
            strcpy(server_boxes[i].box_name, ((request*)arg)->box_name);
            strcpy(server_boxes[i].box_password, ((request*)arg)->box_password);
            break;
        }
    }
    if (tester == 0) {
        server_boxes =
            realloc(server_boxes, sizeof(box) * 2 * (unsigned int)size_boxes);
        if (server_boxes == NULL) exit(1);
        for (int i = size_boxes; i < (2 * size_boxes); i++) {
            server_boxes[i].free = 0;
            my_cond_init(&server_boxes[i].cond_var, NULL);
            my_mutex_init(&server_boxes[i].box_lock, NULL);
        }
        thread_pool[*index].index = size_boxes;
        server_boxes[size_boxes].free = 1;
        strcpy(server_boxes[size_boxes].box_name, ((request*)arg)->box_name);
        strcpy(server_boxes[size_boxes].box_password, ((request*)arg)->box_password);
        size_boxes*=2;
    }
    tester = 0;
    int fd_tfs = tfs_open(((request *)arg)->box_name, TFS_O_CREAT);
    if (fd_tfs == -1) tester = 1;
    tfs_close(fd_tfs);
    signal(SIGPIPE, ignore_signal);
    int fd = my_open(((request *)arg)->pipe_name, O_WRONLY);
    response_manager response;
    response.code = 4;
    if (tester == 1) {
        server_boxes[thread_pool[*index].index].free = 0; //if you cant create the box it really isnt free
        memset(server_boxes[thread_pool[*index].index].box_name, 0, MAX_BOX_NAME);
        memset(server_boxes[thread_pool[*index].index].box_password, 0, MAX_PASSWORD);
        response.return_code = -1;
        strcpy(response.error_message, "Ocorreu um erro na criação da caixa");
    } else {
        response.return_code = 0;
        memset(response.error_message, 0, 1024);
    }
    my_mutex_unlock(&box_size_lock);
    char buffer[MAX_LINE];
    writer_stc(&response, response.code, buffer);
    ssize_t bytes = write(fd, buffer, sizeof(buffer));
    if (bytes == -1) {
        if (errno == EPIPE) {
            return;
        }
    }
    my_close(fd);
    return;
}

void process_manager_unlock(void* arg,int* index) {
    my_mutex_lock(&box_size_lock);
    int tester = 0;
    for (int i = 0; i < size_boxes; i++) {
        if (strcmp(server_boxes[i].box_name, ((request*)arg)->box_name) == 0) {
            if (strcmp(server_boxes[i].box_password, ((request*)arg)->box_password) != 0){ 
                tester = -1;
                break;
            }
            tester = 1;
            thread_pool[*index].index = i;
            memset(server_boxes[i].box_password, 0, MAX_PASSWORD);
            break;
        }
    }
    my_mutex_unlock(&box_size_lock);
    int fd = open(((request*)arg)->pipe_name, O_WRONLY);
    if (fd < 0) return;
    response_manager response;
    response.code = 12;
    if (tester == 1) {
        response.return_code = 0;
        memset(response.error_message, 0, 1024);
    } else if (tester == 0) {
        response.return_code = -1;
        strcpy(response.error_message, "Ocorreu um erro: não existe a box");
    } else {
        response.return_code = -1;
        strcpy(response.error_message, "Ocorreu um erro: palavra-passe errada");
    }
    char buffer[MAX_LINE];
    writer_stc(&response, response.code, buffer);
    ssize_t value = write(fd, buffer, sizeof(buffer));
    if (value != sizeof(buffer)) return;
    close(fd);
}

void process_manager_lock(void* arg, int* index) {
    my_mutex_lock(&box_size_lock);
    int tester = 0;
    for (int i = 0; i < size_boxes; i++) {
        if (strcmp(server_boxes[i].box_name, ((request_new_password*)arg)->request_lock->box_name) == 0) {
            if (strcmp(server_boxes[i].box_password, ((request_new_password*)arg)->request_lock->box_password) != 0){ 
                tester = -1;
                break;
            }
            tester = 1;
            thread_pool[*index].index = i;
            strcpy(server_boxes[i].box_password, ((request_new_password*)arg)->new_password);
            break;
        }
    }
    my_mutex_unlock(&box_size_lock);
    int fd = open(((request_new_password*)arg)->request_lock->pipe_name, O_WRONLY);
    if (fd < 0) return;
    response_manager response;
    response.code = 14;
    if (tester == 1) {
        response.return_code = 0;
        memset(response.error_message, 0, 1024);
    } else if (tester == 0) {
        response.return_code = -1;
        strcpy(response.error_message, "Ocorreu um erro: não existe a box");
    } else {
        response.return_code = -1;
        strcpy(response.error_message, "Ocorreu um erro: palavra-passe errada");
    }
    char buffer[MAX_LINE];
    writer_stc(&response, response.code, buffer);
    ssize_t value = write(fd, buffer, sizeof(buffer));
    if (value != sizeof(buffer)) return;
    close(fd);

}


void *thread_init(void *index) {
    signal(SIGINT, end_program_ctrlC);
    while (1) {
        task *newtask = pcq_dequeue(task_queue);
        newtask->function(newtask->request, (int *)index);
        free(newtask->request);
        free(newtask);
        if (status == END) {
            return NULL;
        }
    }
}

int main(int argc, char **argv) {
    if (argc != 3) {
        fprintf(stderr, "usage: mbroker <pipename>\n");
        exit(1);
    }
    signal(SIGINT, end_program_ctrlC);
    tfs_init(NULL);
    server_pipe = argv[1];
    my_mkfifo(argv[1], 0777);
    server_boxes = my_malloc((unsigned int)atoi(argv[2]) * sizeof(box));
    size_boxes = atoi(argv[2]);
    thread_pool = my_malloc((unsigned int)atoi(argv[2]) * sizeof(thread));
    task_queue = my_malloc(sizeof(pc_queue_t));
    pcq_create(task_queue, (size_t)atoi(argv[2]));
    my_mutex_init(&box_size_lock, NULL);
    my_mutex_init(&thread_lock, NULL);
    my_cond_init(&thread_cond, NULL);
    int index[atoi(argv[2])];
    for (int i = 0; i < atoi(argv[2]); i++) {
        index[i] = i;
    }
    for (int i = 0; i < atoi(argv[2]); i++) {
        thread_pool->index = -1;
        if (pthread_create(&thread_pool->thread, NULL, thread_init, (void *)&index[i]) == -1) exit(1);
        server_boxes[i].free = 0;
        my_cond_init(&server_boxes[i].cond_var, NULL);
        my_mutex_init(&server_boxes[i].box_lock, NULL);
    }
    while (1) {
        int fd = my_open(argv[1], O_RDONLY);
        char buffer[MAX_LINE];
        my_read(fd, buffer, (sizeof(char) * MAX_LINE));
        task *newtask;
        newtask = my_malloc(sizeof(task));
        newtask->request = reader_stc(buffer);
        uint8_t code_pipe;
        memcpy(&code_pipe, buffer, sizeof(uint8_t));
        switch (code_pipe) {
            case 1:
                newtask->function = &process_pub;
                break;
            case 2:
                newtask->function = &process_sub;
                break;
            case 3:
                newtask->function = &process_manager_create;
                break;
            case 5:
                newtask->function = &process_manager_remove;
                break;
            case 7:
                newtask->function = &process_manager_list;
                break;
            case 11:
                newtask->function = &process_manager_unlock;
                break;
            case 13:
                newtask->function = &process_manager_lock;
                break;
            default:
                break;
        }
        if (pcq_enqueue(task_queue, newtask) == -1) {
            return -1;
        }
        memset(buffer, 0, sizeof(buffer));
        my_close(fd);
    }
    return -1;
}
