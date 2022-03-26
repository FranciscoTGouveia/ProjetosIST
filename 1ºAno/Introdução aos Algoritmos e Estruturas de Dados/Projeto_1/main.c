#include "commands.h"

int main() {
    char action;
    Airport airports_vector[MAX_AIRPORTS];
    int airports_counter = 0;
    Flight flights_vector[MAX_FLIGHTS];
    int flights_counter = 0;
    int date = date2int(1, 1, 2022);

    while ((action = getchar()) != EOF) {
        switch (action) {
            case QUIT_CMD: {
                return 0;
            }
            case ADD_AIRPORT_CMD: {
                if (new_airport(airports_vector, airports_counter)) {
                    airports_counter++;
                    sort_airports(airports_vector, airports_counter);
                }
                break;
            }
            case LIST_AIRPORTS_CMD: {
                list_airports(airports_vector, airports_counter);
                break;
            }

            case ADD_FLIGHT_CMD: {
                if (new_flight(airports_vector, airports_counter,
                               flights_vector, flights_counter, date)) {
                    flights_counter++;
                }
                break;
            }
            case LIST_DEPARTURES_CMD: {
                list_departures();
                break;
            }
            case LIST_ARRIVALS_CMD:
                return 0;
            case STEP_DATE_CMD: {
                date = step_date(date);
                break;
            }
        }
    }
    return 0;
}
