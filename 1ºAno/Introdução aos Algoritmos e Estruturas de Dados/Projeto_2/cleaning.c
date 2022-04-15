#include "commands.h"

void delete_flight(Flight flight_vec[], int *flight_count,
                   char *flight_code) {
    int i, j, status = 0;
    for (i = 0; i < *flight_count; i++) {
        if (strcmp(flight_code, flight_vec[i].flight_code) == 0) {
            status = 1;
            (*flight_count)--;
            llist_destroy(flight_vec[i].reservations);
            for (j = i; j < *flight_count; j++) {
                flight_vec[j] = flight_vec[j + 1];
            }
            i--;
        }
    }
    if (status == 0) printf(ERR_NOT_FOUND);
}

void delete_reservation(Flight flight_vec[], int *flight_count,
                        char *res_code) {
    int i, status = 0;
    if (check_invalid_reservation(res_code)) {
        for (i = 0; i < *flight_count; i++) {
            flight_vec[i].reservations =
                llist_delete(flight_vec[i].reservations, res_code,
                             &flight_vec[i], &status);
        }
    }
    if (status == 0) printf(ERR_NOT_FOUND);
}

int delete_fl_rs(Flight flight_vec[], int *flight_count) {
    /* This may be the root of the Mooshak's problems! */
    char buffer[65535];
    scanf("%s", buffer);

    if (strlen(buffer) < 10) {
        delete_flight(flight_vec, flight_count, buffer);
        return 1;
    } else {
        delete_reservation(flight_vec, flight_count, buffer);
        return 1;
    }
    return 0;
}

int destroy_all_res(Flight flight_vec[], int flight_count) {
    /* Cleaning before the program shuts down */
    int i;
    for (i = 0; i < flight_count; i++) {
        llist_destroy(flight_vec[i].reservations);
    }
    return 1;
}
