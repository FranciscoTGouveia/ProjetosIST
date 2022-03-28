#include "commands.h"

static void list_flights_arr(Flight flight_vec[], int flight_count) {
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
        printf("%s %s %02d-%02d-%02d %02d:%02d\n", flight_code, id_dep, day,
               month, year, hours, minutes);
    }
}

void list_arrivals(Airport air_vec[], int air_count, Flight flight_vec[],
                   int flight_count) {
    int i, size_new_flight_vec = 0, new_time, new_date;
    char air_target[MAX_ID + 1];
    Flight new_flight_vec[MAX_FLIGHTS];
    scanf("%s", air_target);
    if (check_airport(air_vec, air_count, air_target)) {
        for (i = 0; i < flight_count; i++) {
            if (strcmp(flight_vec[i].id_arrival, air_target) == 0) {
                new_flight_vec[size_new_flight_vec] = flight_vec[i];
                new_time = calculate_arrival_time(
                    (flight_vec[i].time + flight_vec[i].duration));
                new_date = calculate_arrival_date(
                    (flight_vec[i].time + flight_vec[i].duration),
                    flight_vec[i].date);
                new_flight_vec[size_new_flight_vec].time = new_time;
                new_flight_vec[size_new_flight_vec].date = new_date;
                size_new_flight_vec++;
            }
        }
    }
    sort_flights(new_flight_vec, size_new_flight_vec);
    list_flights_arr(new_flight_vec, size_new_flight_vec);
}
