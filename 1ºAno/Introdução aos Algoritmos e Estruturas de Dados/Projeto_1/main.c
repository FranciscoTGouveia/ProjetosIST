#include "commands.h"

static void execute(char action, Airport air_vec[], int *air_count,
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
    }
}


int main() {
    /* Read a command key and send it to execute */
    char command;
    Airport air_vec[MAX_AIRPORTS];
    Flight flights_vec[MAX_FLIGHTS];
    int air_count = 0, flights_count = 0;
    int date = date2int(1, 1, 2022);

    while ((command = getchar()) != EOF && command != QUIT_CMD) {
        execute(command, air_vec, &air_count, flights_vec, &flights_count,
                &date);
    }
    return 0;
}
