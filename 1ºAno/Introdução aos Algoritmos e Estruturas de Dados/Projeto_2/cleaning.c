#include "commands.h"

int delete_fl_rs(Flight flight_vec[], int *flight_count) {
    /* This may be the root of the Mooshak's problems! */
    int i, j;
    char buffer[65535], *code;
    scanf("%s", buffer);
    code = (char *)malloc(strlen(buffer) + 1);
    strcpy(code, buffer);

    for (i = 0; i < *flight_count; i++) {
        if (strcmp(code, flight_vec[i].flight_code) == 0) {
            free(code);
            (*flight_count)--;
            for (j = i; j < *flight_count; j++) {
                flight_vec[i] = flight_vec[i + 1];
                return 1;
            }
        }
    }
    printf(ERR_NOT_FOUND);
    return 0;
}

int destroy_all_res(Flight flight_vec[], int flight_count) {
    int i;
    for (i = 0; i < flight_count; i++) {
        llist_destroy(flight_vec[i].reservations);
    }
    return 1;
}
