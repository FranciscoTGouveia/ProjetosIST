#include "commands.h"

void delete_flight(Flight flight_vec[], int *flight_count, char *flight_code,
                   int curr_date) {
    /* Iterate over the flights vector, and delete a flight from the vector,
    and delete the linked list of reservations associated with it */
    int i, j, status = 0;
    for (i = 0; i < *flight_count; i++) {
        if (strcmp(flight_code, flight_vec[i].flight_code) == 0 &&
            flight_vec[i].time < curr_date) {
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
    /* Iterate over the flight vector and delete a reservation from the linked
    list associated with that flight */
    int i, status = 0;
    for (i = 0; i < *flight_count; i++) {
        flight_vec[i].reservations = llist_delete(
            flight_vec[i].reservations, res_code, &flight_vec[i], &status);
    }
    if (status == 0) printf(ERR_NOT_FOUND);
}

int delete_fl_rs(Flight flight_vec[], int *flight_count, int curr_date) {
    /* Delete a flight or a reservation, according to the input */
    char buffer[65535];
    scanf("%s", buffer);

    if (strlen(buffer) < 10) {
        delete_flight(flight_vec, flight_count, buffer, curr_date);
        return 1;
    } else {
        delete_reservation(flight_vec, flight_count, buffer);
        return 1;
    }
    return 0;
}

int destroy_all_res(Flight flight_vec[], int flight_count,
                    Hash_Table *my_table) {
    /* Clean all the reservations linked lists and the hash table */
    int i;
    for (i = 0; i < flight_count; i++) {
        llist_destroy(flight_vec[i].reservations);
    }
    destroy_hash_table(my_table);
    return 1;
}
