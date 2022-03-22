#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include "actions.h"

static void add_airport_to_vector(char id[], char country[], char city[],
                                  Airport airports_vector[],
                                  int airports_counter) {

    strcpy(airports_vector[airports_counter].id, id);
    strcpy(airports_vector[airports_counter].country, country);
    strcpy(airports_vector[airports_counter].city, city);
}

static void print_airport_id(Airport airports_vector[],
                             int airports_counter) {
    printf("airport %s\n", airports_vector[airports_counter].id);
}

/* Check if an ID is valid (all upper letters) */
static int check_invalid_id(char id[]) {
    int i;
    for (i = 0; i < MAX_ID; i++) {
        if (!isupper(id[i])) {
            printf("invalid airport ID\n");
            return 1;
        }
    }
    return 0;
}

/* Check if the new airport will not exceed the limit */
static int check_2_many(int airports_counter) {
    if (airports_counter >= MAX_AIRPORTS) {
        printf("too many airports\n");
        return 1;
    }
    return 0;
}

static int check_duplicates(Airport airports_vector[], char id[],
                            int airports_counter) {
    int i;
    for (i = 0; i < airports_counter; i++) {
        if (strcmp(airports_vector[i].id, id) == 0) {
            printf("duplicate airport\n");
            return 1;
        }
    }
    return 0;
}

int new_airport(Airport airports_vector[], int airports_counter) {
    char id[MAX_ID + 1];
    char country[MAX_COUNTRY + 1];
    char city[MAX_CITY + 1];
    int status_id, status_2_many, status_duplicate;
    scanf("%s %s %[^\n]s", id, country, city);
    status_id = check_invalid_id(id);
    status_2_many = check_2_many(airports_counter);
    status_duplicate =
        check_duplicates(airports_vector, id, airports_counter);
    if (status_id || status_2_many || status_duplicate) {
        return 1;
    }
    add_airport_to_vector(id, country, city, airports_vector,
                          airports_counter);
    print_airport_id(airports_vector, airports_counter);
    return 0;
}
