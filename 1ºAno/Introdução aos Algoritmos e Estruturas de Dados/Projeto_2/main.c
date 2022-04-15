#include "commands.h"

void *my_malloc(Flight flight_vec[], int flight_count, int size) {
    int *res = malloc(size);
    if (*res == 0) {
        printf(ERR_NO_MEMORY);
        destroy_all_res(flight_vec, flight_count);
        exit(0);
    }
    return res;
}

static int execute(char action, Airport air_vec[], int *air_count,
                   Flight flights_vec[], int *flights_count, int *date) {
    /* Call the appropriate function for the command */
    switch (action) {
        case ADD_AIRPORT_CMD:
            new_airport(air_vec, air_count);
            break;
        case LIST_AIRPORTS_CMD:
            list_airports(air_vec, *air_count, flights_vec, *flights_count);
            break;
        case ADD_FLIGHT_CMD:
            new_flight(air_vec, *air_count, flights_vec, flights_count,
                       *date);
            break;
        case LIST_DEPARTURES_CMD:
            list_departures(air_vec, *air_count, flights_vec, *flights_count);
            break;
        case LIST_ARRIVALS_CMD:
            list_arrivals(air_vec, *air_count, flights_vec, *flights_count);
            break;
        case STEP_DATE_CMD:
            *date = step_date(*date);
            break;
        case ADD_RESERVATION_CMD:
            add_reservation(*date, flights_vec, *flights_count);
            break;
        case DELETE_RESERVATION_CMD:
            delete_fl_rs(flights_vec, flights_count);
            break;
        case QUIT_CMD:
            destroy_all_res(flights_vec, *flights_count);
            return 0;
    }
    return 1;
}

int main() {
    /* Read a command key and send it to execute */
    char command;
    Airport air_vec[MAX_AIRPORTS];
    Flight flights_vec[MAX_FLIGHTS];
    int air_count = 0, flights_count = 0, date, execute_status = 1;
    date = date2int(1, 1, 2022);

    while ((command = getchar()) != EOF && execute_status) {
        execute_status = execute(command, air_vec, &air_count, flights_vec,
                                 &flights_count, &date);
    }
    return 0;
}
