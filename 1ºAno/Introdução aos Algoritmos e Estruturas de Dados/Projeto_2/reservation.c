#include "commands.h"
#include <stdio.h>
#include <string.h>

Reservation *llist_pop(Reservation *head) {
    Reservation *n = head->next;
    free(head->res_code);
    free(head);
    return n;
}

Reservation *llist_delete(Reservation *head, char *res_code, Flight *flight,
                          int *status) {
    Reservation *prev = NULL, *temp = head;
    while (temp) {
        if (strcmp(res_code, temp->res_code) == 0) {
            *status = 1;
            if (temp == head)
                head = temp->next;
            else
                prev->next = temp->next;
            flight->num_res -= temp->num_pass;
            free(temp->res_code);
            free(temp);
        }
        prev = temp;
        temp = temp->next;
    }
    return head;
}

Reservation *llist_push(Reservation *head, char *res_code, int num_pass) {
    Reservation *current;
    Reservation *new = (Reservation *)malloc(sizeof(Reservation));
    new->num_pass = num_pass;
    new->res_code = res_code;
    if (head == NULL || strcmp(head->res_code, new->res_code) >= 0) {
        new->next = head;
        head = new;
        return new;
    }
    current = head;
    while (current->next != NULL &&
           strcmp(current->next->res_code, new->res_code) < 0) {
        current = current->next;
    }
    new->next = current->next;
    current->next = new;
    return head;
}

Reservation *llist_destroy(Reservation *head) {
    while (head) {
        head = llist_pop(head);
    }
    return NULL;
}

void llist_print(Reservation *head) {
    while (head) {
        printf("%s %d\n", head->res_code, head->num_pass);
        head = head->next;
    }
}

int add_reservation2flight(Flight flight_vec[], int flight_count,
                           char *flight_code, int date, char *res_code,
                           int passengers) {
    int i;
    for (i = 0; i < flight_count; i++) {
        if (date == flight_vec[i].date &&
            strcmp(flight_code, flight_vec[i].flight_code) == 0) {
            flight_vec[i].reservations =
                llist_push(flight_vec[i].reservations, res_code, passengers);
            flight_vec[i].num_res += passengers;
            return 1;
        }
    }
    return 0;
}

int list_reservations(Flight flight_vec[], int flight_count,
                      char *flight_code, int date) {
    int i;
    for (i = 0; i < flight_count; i++) {
        if (date == flight_vec[i].date &&
            strcmp(flight_vec[i].flight_code, flight_code) == 0) {
            llist_print(flight_vec[i].reservations);
            return 1;
        }
    }
    return 0;
}

int check_invalid_reservation(char *res_code) {
    /* Check if the reservation code is valid */
    int i;
    int code_length = strlen(res_code);
    if (code_length < 10) {
        printf(ERR_INVALID_RESERVATION_CODE);
        return 0;
    }
    for (i = 0; i < code_length; i++) {
        if (!(isupper(res_code[i]) || isdigit(res_code[i]))) {
            printf(ERR_INVALID_RESERVATION_CODE);
            return 0;
        }
    }
    return 1;
}

int check_if_flight_code(Flight flight_vec[], int flight_count,
                         char *flight_code, int date) {
    int i;
    for (i = 0; i < flight_count; i++) {
        if (strcmp(flight_vec[i].flight_code, flight_code) == 0 &&
            date == flight_vec[i].date)
            return 1;
    }
    printf("%s: ", flight_code);
    printf(ERR_FLIGHT_DOES_NOT_EXIST);

    return 0;
}

int check_reservation_code_used(Flight flight_vec[], int flight_count,
                                char *res_code) {
    int i;
    Reservation *temp;
    for (i = 0; i < flight_count; i++) {
        temp = flight_vec[i].reservations;
        while (temp) {
            if (strcmp(temp->res_code, res_code) == 0) {
                printf("%s: ", res_code);
                printf(ERR_RESERVATION_ALREADY_USED);
                return 0;
            }
            temp = temp->next;
        }
    }
    return 1;
}

int check_2_many_reservations(Flight flight_vec[], int flight_count,
                              char *flight_code, int pass) {
    int i;
    for (i = 0; i < flight_count; i++) {
        if (strcmp(flight_vec[i].flight_code, flight_code) == 0 &&
            flight_vec[i].num_res + pass > flight_vec[i].capacity) {
            printf(ERR_TOO_MANY_RESERVATIONS);
            return 0;
        }
    }
    return 1;
}

int check_reservation_date(int last_date, int new_date) {
    if (!check_date(last_date, new_date)) {
        printf(ERR_INVALID_DATE);
        return 0;
    }
    return 1;
}

int check_passengers_num(int passengers) {
    if (passengers <= 0) {
        printf(ERR_INVALID_PASSENGERS);
        return 0;
    }
    return 1;
}

int check_reservation(char *res_code, int last_date, int new_date,
                      Flight flight_vec[], int flight_count,
                      char *flight_code, int passengers) {
    return (check_invalid_reservation(res_code) &&
            check_if_flight_code(flight_vec, flight_count, flight_code,
                                 new_date) &&
            check_reservation_code_used(flight_vec, flight_count, res_code) &&
            check_2_many_reservations(flight_vec, flight_count, flight_code,
                                      passengers) &&
            check_reservation_date(last_date, new_date) &&
            check_passengers_num(passengers))
               ? 1
               : 0;
}

void add_reservation(int last_date, Flight flight_vec[], int flight_count) {
    /* Max input is 65535 chars */
    /* flight_code is 7, day 1, month 1, year 1, passengers 1 */
    /* the final 65524 */
    char buffer[65535];
    char flight_code[7], aux_code[65524], *res_code;
    int day, month, year, date, passengers, args;
    scanf("%[^\n]s", buffer);
    args = sscanf(buffer, "%s %d-%d-%d %s %d", flight_code, &day, &month,
                  &year, aux_code, &passengers);
    date = date2int(day, month, year);
    if (args == 6) {
        if (check_reservation(aux_code, last_date, date, flight_vec,
                              flight_count, flight_code, passengers)) {
            res_code = (char *)malloc(strlen(aux_code) + 1);
            strcpy(res_code, aux_code);
            add_reservation2flight(flight_vec, flight_count, flight_code,
                                   date, res_code, passengers);
        }
    } else {
        if (check_if_flight_code(flight_vec, flight_count, flight_code,
                                 date) &&
            check_reservation_date(last_date, date)) {
            list_reservations(flight_vec, flight_count, flight_code, date);
        }
    }
}
