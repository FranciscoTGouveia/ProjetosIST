#include "writer_stc.h"
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

void writer_stc_request(request *new_request, char buffer[MAX_LINE]) {
    size_t offset = 0;
    memcpy(buffer, &new_request->code, sizeof(uint8_t));
    offset += sizeof(uint8_t);
    memcpy(buffer + offset, new_request->pipe_name, sizeof(new_request->pipe_name));
    offset += (sizeof(char)*MAX_PIPE_NAME);
    memcpy(buffer + offset, new_request->box_name, sizeof(new_request->box_name));
    offset += (sizeof(char)*MAX_BOX_NAME);
    memcpy(buffer + offset, new_request->box_password, sizeof(new_request->box_password));
}

void writer_stc_response_manager(response_manager *new_request,
                                 char buffer[MAX_LINE]) {
    size_t offset = 0;
    memcpy(buffer, &new_request->code, sizeof(uint8_t));
    offset += sizeof(uint8_t);
    memcpy(buffer + offset, &new_request->return_code, sizeof(int32_t));
    offset += sizeof(int32_t);
    memcpy(buffer + offset, new_request->error_message,
           sizeof(new_request->error_message));
}

void writer_stc_list_request(list_manager_request *new_request,
                             char buffer[MAX_LINE]) {
    memcpy(buffer, &new_request->code, sizeof(uint8_t));
    memcpy(buffer + sizeof(uint8_t), new_request->pipe_name,
           sizeof(new_request->pipe_name));
}

void writer_stc_list_response(list_manager_response *new_request,
                              char buffer[MAX_LINE]) {
    size_t offset = 0;
    memcpy(buffer, &new_request->code, sizeof(uint8_t));
    offset += sizeof(uint8_t);
    memcpy(buffer + offset, &new_request->last, sizeof(uint8_t));
    offset += sizeof(uint8_t);
    memcpy(buffer + offset, new_request->box_name,
           sizeof(new_request->box_name));
    offset += (sizeof(char) * MAX_BOX_NAME);
    memcpy(buffer + offset, &new_request->box_size, sizeof(uint64_t));
    offset += sizeof(uint64_t);
    memcpy(buffer + offset, &new_request->n_pubs, sizeof(uint64_t));
    offset += sizeof(uint64_t);
    memcpy(buffer + offset, &new_request->n_subs, sizeof(uint64_t));
    offset += sizeof(uint64_t);
    memcpy(buffer + offset, new_request->box_password, sizeof(new_request->box_password));
}

void writer_stc_message(messages_pipe *new_request, char buffer[MAX_LINE]) {
    memcpy(buffer, &new_request->code, sizeof(uint8_t));
    memcpy(buffer + sizeof(uint8_t), new_request->message,
           sizeof(new_request->message));
}

void writer_stc_new_password(request_new_password* new_request, char buffer[MAX_LINE]) {
    size_t offset = sizeof(uint8_t) + (sizeof(char)*MAX_PIPE_NAME) + (sizeof(char)*MAX_BOX_NAME) +
    (sizeof(char)*MAX_PASSWORD);
    writer_stc_request(new_request->request_lock, buffer);
    memcpy(buffer + offset, new_request->new_password, sizeof(char)*MAX_PASSWORD);
}

void writer_stc(void *new_request, uint8_t code_pipe, char buffer[MAX_LINE]) {
    memset(buffer, 0, MAX_LINE);
    switch (code_pipe) {
        case 4:
        case 6:
        case 12:
        case 14:
            writer_stc_response_manager(new_request, buffer);
            break;
        case 7:
            writer_stc_list_request(new_request, buffer);
            break;
        case 8:
            writer_stc_list_response(new_request, buffer);
            break;
        case 9:
        case 10:
            writer_stc_message(new_request, buffer);
            break;
        case 13:
            writer_stc_new_password(new_request, buffer);
            break;
        default:
            writer_stc_request(new_request, buffer);
            break;
    }
}