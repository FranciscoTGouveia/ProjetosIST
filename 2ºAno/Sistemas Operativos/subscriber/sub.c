#include "../utils/logging.h"
#include "../utils/pipeflow.h"
#include "../utils/reader_stc.h"
#include "../utils/writer_stc.h"
#include "../utils/safety_mechanisms.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <signal.h>

int fd;
char *pipe_name;
int counter = 0;

void getCTRLC(int s) {
    (void)s;
    signal(SIGINT, getCTRLC);
    char buffer[100];
    int value = snprintf(buffer, sizeof(buffer) - 1, "%d", counter);
    my_write(STDOUT_FILENO, buffer, (size_t)value);
    my_close(fd);
    my_unlink(pipe_name);
    exit(0);
}

int main(int argc, char **argv) {
    if (argc != 4 && argc != 5) {
    fprintf(stderr, "usage: sub <register_pipe_name> <box_name>\n");
    }
    pipe_name = argv[2];
    request newrequest;
    newrequest.code = 2;
    strcpy(newrequest.pipe_name, pipe_name);
    char box_name_slash[MAX_BOX_NAME];
    memset(box_name_slash, 0, MAX_BOX_NAME);
    strcpy(box_name_slash, "/");
    strcat(box_name_slash, argv[3]);
    strcpy(newrequest.box_name, box_name_slash);
    if (argc == 4) {
        char password[MAX_PASSWORD];
        memset(password, 0, sizeof(char)*MAX_PASSWORD);
        strcpy(newrequest.box_password, password);
    } else {
        strcpy(newrequest.box_password, argv[argc-1]);
    }
    char server_request[MAX_LINE];
    writer_stc(&newrequest, newrequest.code, server_request);
    fd = my_open(argv[1], O_WRONLY);
    my_write(fd, server_request, sizeof(server_request));
    my_close(fd);
    my_mkfifo(argv[2], 0777);
    signal(SIGINT, getCTRLC);
    fd = my_open(argv[2], O_RDONLY);
    while (1) {
        char message[MAX_LINE];
        memset(message, 0, MAX_LINE);
        if (read(fd, message, sizeof(message)) == 0) break;
        counter++;
        messages_pipe *new_message = reader_stc(message);
        fprintf(stdout, "%s\n", new_message->message);
        free(new_message);
    }
    my_close(fd);
    my_unlink(pipe_name);
    return -1;
}
