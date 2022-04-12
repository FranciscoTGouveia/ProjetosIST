#include "commands.h"

static int check_if_airport(Airport air_vec[], int air_count, char id[]) {
    /* Check if the airport is in the vector */
    if (binary_search(air_vec, id, 0, air_count) != -1) return 1;
    printf("%s: ", id);
    printf(ERR_NO_SUCH_AIRPORT_ID);
    return 0;
}


static int num_flights(Flight flight_vec[], int flight_count, char id[]) {
    /* Iterate over flight's vector and count the departures */
    int i, counter = 0;
    for (i = 0; i < flight_count; i++) {
        if (strcmp(id, flight_vec[i].id_departure) == 0) counter++;
    }
    return counter;
}


static void print_airport_info(Airport airport, Flight flight_vec[],
                               int flight_count) {
    /* Print the correct information of the passed airport */
    int flights = num_flights(flight_vec, flight_count, airport.id);
    printf("%s %s %s %d\n", airport.id, airport.city, airport.country,
           flights);
}


static void get_airport_info_by_id(char id[MAX_ID + 1], Airport air_vec[],
                                   int air_count, Flight flight_vec[],
                                   int flight_count) {
    /* Print the aiport info by the ID passed as argument */
    int index = binary_search(air_vec, id, 0, air_count);
    print_airport_info(air_vec[index], flight_vec, flight_count);
}


void list_airports(Airport air_vec[], int air_count, Flight flight_vec[],
                   int flight_count) {
    /* Execute the error checking and print the airport's info */
    char id[MAX_ID + 1], listen_char;
    int i, no_arguments = 1;
    while ((listen_char = getchar()) != '\n') {
        scanf("%s", id);
        no_arguments = 0;
        if (check_if_airport(air_vec, air_count, id))
            get_airport_info_by_id(id, air_vec, air_count, flight_vec,
                                   flight_count);
    }
    if (no_arguments) {
        for (i = 0; i < air_count; i++) {
            print_airport_info(air_vec[i], flight_vec, flight_count);
        }
    }
}
