#include "commands.h"

/*static int check_if_flight(char id[]) {
    int status_flight_code = check_flight_code(id);
    return (status_flight_code);
}*/

static void print_all_flights(Flight flight_vec[], int flight_count) {
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
        printf("%s %s %s %02d-%02d-%02d %02d:%02d\n", flight_code, id_dep,
               id_arr, day, month, year, hours, minutes);
    }
}

static void add_flight_to_vector(Flight flight_vec[], int flight_count,
                                 char flight_code[], char id_dep[],
                                 char id_arr[], int day, int month, int year,
                                 int dep_h, int dep_m, int dur_h, int dur_m,
                                 int capacity) {
    strcpy(flight_vec[flight_count].flight_code, flight_code);
    strcpy(flight_vec[flight_count].id_departure, id_dep);
    strcpy(flight_vec[flight_count].id_arrival, id_arr);
    flight_vec[flight_count].date = date2int(day, month, year);
    flight_vec[flight_count].time = time2int(dep_h, dep_m);
    flight_vec[flight_count].duration = time2int(dur_h, dur_m);
    flight_vec[flight_count].capacity = capacity;
}

int new_flight(Flight flight_vec[], int flight_count) {
    char flight_code[MAX_FLIGHT_CODE + 1], id_dep[MAX_ID + 1],
        id_arr[MAX_ID + 1], listen_char;
    int day, month, year, dep_h, dep_m, dur_h, dur_m, capacity,
        no_arguments = 1;

    while ((listen_char = getchar()) != '\n') {
        scanf("%s %s %s %d-%d-%d %d:%d %d:%d %d", flight_code, id_dep, id_arr,
              &day, &month, &year, &dep_h, &dep_m, &dur_h, &dur_m, &capacity);
        no_arguments = 0;
        add_flight_to_vector(flight_vec, flight_count, flight_code, id_dep,
                             id_arr, day, month, year, dep_h, dep_m, dur_h,
                             dur_m, capacity);
        return 1;
    }
    if (no_arguments) {
        print_all_flights(flight_vec, flight_count);
    }
    return 0;
}
