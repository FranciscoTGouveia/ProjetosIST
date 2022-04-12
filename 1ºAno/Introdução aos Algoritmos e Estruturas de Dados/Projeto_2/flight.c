#include "commands.h"

static int check_flight_code(char code[]) {
    /* A flight code has 2 uppercase letters anda number between 1 and 9999 */
    int status = 1;
    if (strlen(code) < 3 || strlen(code) > 6) {
        status = 0;
    } else if (!(isupper(code[0]) && isupper(code[1]))) {
        status = 0;
    } else if (code[2] == '0') {
        status = 0;
    }
    if (!status) {
        printf(ERR_INVALID_FLIGHT_CODE);
    }
    return status;
}


static int check_already_exists(Flight flight_vec[], int flight_count,
                                char code[], int day, int month, int year) {
    /* Iterate over flights and check if there isn't a similar code */
    int i;
    for (i = 0; i < flight_count; i++) {
        if (strcmp(flight_vec[i].flight_code, code) == 0 &&
            same_day(flight_vec[i].date, day, month, year)) {
            printf(ERR_FLIGHT_ALREADY_EXISTS);
            return 0;
        }
    }
    return 1;
}


int binary_search(Airport air_vec[], char target[], int l, int r) {
    /* Implement binary search since the air_vec is sorted */
    int mid;
    if (r >= l) {
        mid = l + (r - l) / 2;
        if (strcmp(air_vec[mid].id, target) == 0) {
            return mid;
        } else if (strcmp(air_vec[mid].id, target) > 0) {
            return binary_search(air_vec, target, l, mid - 1);
        } else {
            return binary_search(air_vec, target, mid + 1, r);
        }
    }
    return -1;
}


static int check_airports_exist(Airport air_vec[], char id_dep[],
                                char id_arr[], int air_count) {
    /* Check if the airports of arrival and departure exist */ 
    if (binary_search(air_vec, id_dep, 0, air_count - 1) == -1) {
        printf("%s: ", id_dep);
        printf(ERR_NO_SUCH_AIRPORT_ID);
        return 0;
    } else if (binary_search(air_vec, id_arr, 0, air_count - 1) == -1) {
        printf("%s: ", id_arr);
        printf(ERR_NO_SUCH_AIRPORT_ID);
        return 0;
    }
    return 1;
}


static int check_2_many_flights(int flight_count) {
    /* Check if the flight_vector can take more flights */
    if (flight_count >= MAX_FLIGHTS) {
        printf(ERR_TOO_MANY_FLIGHTS);
        return 0;
    }
    return 1;
}


static int check_flight_date(int day, int month, int year, int date) {
    /* Check if the flight has a valid date */
    int test_date = date2int(day, month, year);
    if (!(check_date(date, test_date))) {
        printf(ERR_INVALID_DATE);
        return 0;
    }
    return 1;
}


static int check_duration(int dur_h, int dur_m) {
    /* Check if the flight has a valid duration */
    int time = time2int(dur_h, dur_m);
    /* 12 hours are 720 minutes */
    if (time > 720) {
        printf(ERR_INVALID_DURATION);
        return 0;
    }
    return 1;
}


static int check_capacity(int capacity) {
    /* Check if the capacity of the flight is valid */
    if (!(capacity >= 10 && capacity <= 100)) {
        printf(ERR_INVALID_CAPACITY);
        return 0;
    }
    return 1;
}


static int check_if_flight(Airport air_vec[], int air_count,
                           Flight flight_vec[], int flight_count,
                           char flight_code[], int day, int month, int year,
                           char id_dep[], char id_arr[], int date, int dur_h,
                           int dur_m, int capacity) {
    /* Aggregate all error-checking before the adding of the new flight */
    return (check_flight_code(flight_code) &&
            check_already_exists(flight_vec, flight_count, flight_code, day,
                                 month, year) &&
            check_airports_exist(air_vec, id_dep, id_arr, air_count) &&
            check_2_many_flights(flight_count) &&
            check_flight_date(day, month, year, date) &&
            check_duration(dur_h, dur_m) && check_capacity(capacity));
}


static void print_all_flights(Flight flight_vec[], int flight_count) {
    /* Iterate over flights_vector and print flight info */
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
    /* Add the new flight to vector */
    strcpy(flight_vec[flight_count].flight_code, flight_code);
    strcpy(flight_vec[flight_count].id_departure, id_dep);
    strcpy(flight_vec[flight_count].id_arrival, id_arr);
    flight_vec[flight_count].date = date2int(day, month, year);
    flight_vec[flight_count].time = time2int(dep_h, dep_m);
    flight_vec[flight_count].duration = time2int(dur_h, dur_m);
    flight_vec[flight_count].capacity = capacity;
}

void new_flight(Airport air_vec[], int air_count, Flight flight_vec[],
                int *flight_count, int date) {
    char flight_code[MAX_FLIGHT_CODE + 1], id_dep[MAX_ID + 1],
        id_arr[MAX_ID + 1], listen_char;
    int day, month, year, dep_h, dep_m, dur_h, dur_m, capacity,
        no_arguments = 1;

    while ((listen_char = getchar()) != '\n') {
        scanf("%s %s %s %d-%d-%d %d:%d %d:%d %d", flight_code, id_dep, id_arr,
              &day, &month, &year, &dep_h, &dep_m, &dur_h, &dur_m, &capacity);
        no_arguments = 0;
        /* Check errors and flight to vector */
        if (check_if_flight(air_vec, air_count, flight_vec, *flight_count,
                            flight_code, day, month, year, id_dep, id_arr,
                            date, dur_h, dur_m, capacity)) {
            add_flight_to_vector(flight_vec, *flight_count, flight_code,
                                 id_dep, id_arr, day, month, year, dep_h,
                                 dep_m, dur_h, dur_m, capacity);
            (*flight_count)++;
        }
    }
    if (no_arguments) {
        print_all_flights(flight_vec, *flight_count);
    }
}
