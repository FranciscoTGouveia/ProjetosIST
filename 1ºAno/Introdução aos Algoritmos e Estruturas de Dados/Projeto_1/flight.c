#include "commands.h"

static int check_flight_code(char id[]) {
    int invalid = 0;
    if (!(isupper(id[0]) && isupper(id[0]))) {
        invalid = 1;
    }
    if (id[2] == '0' || isdigit(id[3] || isdigit(id[4]) || isdigit(id[5]))) {
        invalid = 1;
    }

    if (invalid) {
        printf(ERR_INVALID_FLIGHT_CODE);
        return 0;
    }
    return 1;
}

static int check_if_flight(char id[]) {
    int status_flight_code = check_flight_code(id);
    return (status_flight_code);
}

int new_flight(Flight flight_vec[], int flight_count) {
    char flight_code[MAX_FLIGHT_CODE + 1];
    char id_departure[MAX_ID + 1];
    char id_arrival[MAX_ID + 1];
    char date[MAX_DATE + 1];
    char time[MAX_TIME + 1];
    short duration;
    short capacity;

    int no_arguments = 1;
    char listen_char;

    while ((listen_char = getchar()) != '\n') {
        scanf("%s %s %s %s %s %hd %hd", flight_code, id_departure, id_arrival,
              date, time, &duration, &capacity);
        no_arguments = 0;
        if (check_if_flight(flight_code)) {
            strcpy(flight_vec[flight_count].flight_code, flight_code);
            strcpy(flight_vec[flight_count].id_departure, id_departure);
            strcpy(flight_vec[flight_count].id_arrival, flight_code);
            strcpy(flight_vec[flight_count].date, date);
            strcpy(flight_vec[flight_count].time, time);
            return 1;
        }
    }
    return 0;
}
