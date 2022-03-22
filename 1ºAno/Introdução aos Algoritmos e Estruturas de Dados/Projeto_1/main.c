#include "commands.h"

int main() {
    char action;
    Airport airports_vector[MAX_AIRPORTS];
    int airports_counter = 0;

    while ((action = getchar()) != EOF) {
        switch (action) {
            case QUIT_CMD: {
                return 0;
            }
            case ADD_AIRPORT_CMD: {
                if (new_airport(airports_vector, airports_counter) == 0) {
                    airports_counter++;
                }
                break;
            }
            case LIST_AIRPORTS_CMD:
                return 0;
            case ADD_FLIGHT_CMD:
                return 0;
            case LIST_DEPARTURES_CMD:
                return 0;
            case LIST_ARRIVALS_CMD:
                return 0;
            case STEP_TIME_CMD:
                return 0;
        }
        action = getchar();
    }
    return 0;
}
