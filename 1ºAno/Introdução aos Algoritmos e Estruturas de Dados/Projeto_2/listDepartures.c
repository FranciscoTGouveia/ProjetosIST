#include "commands.h"

void sort_flights(Flight flight_vec[], int flights_count) {
    /* Implement a bubble sort to sort by date and time */
    int i, j;
    Flight temp;
    for (i = 0; i < (flights_count - 1); i++) {
        for (j = 0; j < (flights_count - i - 1); j++) {
            if (flight_vec[j + 1].date < flight_vec[j].date ||
                (flight_vec[j + 1].date == flight_vec[j].date &&
                 flight_vec[j + 1].time < flight_vec[j].time)) {
                temp = flight_vec[j];
                flight_vec[j] = flight_vec[j + 1];
                flight_vec[j + 1] = temp;
            }
        }
    }
}


static void list_flights_dep(Flight flight_vec[], int flight_count) {
    /* Print flight's info that departure from the airport (argument) */
    int i, day, month, year, hours, minutes, date, time;
    char flight_code[MAX_FLIGHT_CODE + 1], id_dep[MAX_ID + 1],
        id_arr[MAX_ID + 1];
    for (i = 0; i < flight_count; i++) {
        date = flight_vec[i].date;
        time = flight_vec[i].time;
        day = (date & 0xff);
        month = ((date >> 8) & 0xff);
        year = ((date >> 16) & 0xffff);
        hours = time / 60;
        minutes = time % 60;
        strcpy(flight_code, flight_vec[i].flight_code);
        strcpy(id_dep, flight_vec[i].id_departure);
        strcpy(id_arr, flight_vec[i].id_arrival);
        printf("%s %s %02d-%02d-%02d %02d:%02d\n", flight_code, id_arr, day,
               month, year, hours, minutes);
    }
}


int check_airport(Airport air_vec[], int air_count, char air_target[]) {
    /* Check if there the air_target airport in airports_vector */
    if (binary_search(air_vec, air_target, 0, air_count) == -1) {
        printf("%s: ", air_target);
        printf(ERR_NO_SUCH_AIRPORT_ID);
        return 0;
    }
    return 1;
}

void list_departures(Airport air_vec[], int air_count, Flight flight_vec[],
                     int flight_count) {
    /* Create a vector with the flights that departure from air_target */
    int i, size_new_flight_vec = 0;
    char air_target[MAX_ID + 1];
    Flight new_flight_vec[MAX_FLIGHTS];
    scanf("%s", air_target);

    if (check_airport(air_vec, air_count, air_target)) {
        for (i = 0; i < flight_count; i++) {
            if (strcmp(flight_vec[i].id_departure, air_target) == 0) {
                new_flight_vec[size_new_flight_vec] = flight_vec[i];
                size_new_flight_vec++;
            }
        }
    }
    sort_flights(new_flight_vec, size_new_flight_vec);
    list_flights_dep(new_flight_vec, size_new_flight_vec);
}
