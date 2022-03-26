#include "commands.h"

static int check_if_airport(Airport airports_vector[], int airports_counter,
                            char id[]) {
    int i;
    for (i = 0; i < airports_counter; i++) {
        if (strcmp(airports_vector[i].id, id) == 0) {
            return 1;
        }
    }
    printf("%s: ", id);
    printf(ERR_NO_SUCH_AIRPORT_ID);
    return 0;
}

int get_num_flights_airport() {
    /*int i, counter = 0;
    for (i = 0; i < flight_count; i++) {
        if (strcmp(id, flight_vec[i].id_departure) == 0) {
            counter++;
        }
    }*/
    return 0;
}

static void print_airport_info(Airport airport) {
    int num_flights;
    char id[MAX_ID + 1], city[MAX_CITY + 1], country[MAX_COUNTRY + 1];
    strcpy(id, airport.id);
    strcpy(city, airport.city);
    strcpy(country, airport.country);
    num_flights = get_num_flights_airport();
    printf("%s %s %s %d\n", id, city, country, num_flights);
}

static void get_airport_info_by_id(char id[MAX_ID + 1],
                                   Airport airports_vector[],
                                   int airports_counter) {
    int i;
    /* Implement binary_search if needed */
    for (i = 0; i < airports_counter; i++) {
        if (strcmp(airports_vector[i].id, id) == 0) {
            print_airport_info(airports_vector[i]);
            break;
        }
    }
}

void list_airports(Airport airports_vector[], int airports_counter) {
    int ids_counter = 0, no_arguments = 1, i;
    char ids_vector[MAX_AIRPORTS][MAX_ID + 1], listen_char;

    while ((listen_char = getchar()) != '\n') {
        scanf("%s", ids_vector[ids_counter]);
        no_arguments = 0;
        if (check_if_airport(airports_vector, airports_counter,
                             ids_vector[ids_counter])) {
            get_airport_info_by_id(ids_vector[ids_counter], airports_vector,
                                   airports_counter);
            ids_counter++;
        }
    }
    if (no_arguments) {
        for (i = 0; i < airports_counter; i++) {
            print_airport_info(airports_vector[i]);
        }
    }
}
