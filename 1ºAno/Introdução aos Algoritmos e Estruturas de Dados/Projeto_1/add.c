#include "commands.h"

static void add_airport_to_vector(char id[], char country[], char city[],
                                  Airport airports_vector[],
                                  int airports_counter) {

    strcpy(airports_vector[airports_counter].id, id);
    strcpy(airports_vector[airports_counter].country, country);
    strcpy(airports_vector[airports_counter].city, city);
}

/* Check if an ID is valid (all upper letters) */
static int check_invalid_id(char id[]) {
    int i;
    for (i = 0; i < MAX_ID; i++) {
        if (!isupper(id[i])) {
            printf(ERR_INVALID_AIRPORT_ID);
            return 0;
        }
    }
    return 1;
}

/* Check if the new airport will not exceed the limit */
static int check_2_many(int airports_counter) {
    if (airports_counter >= MAX_AIRPORTS) {
        printf(ERR_TOO_MANY_AIRPORTS);
        return 0;
    }
    return 1;
}

static int check_duplicates(Airport airports_vector[], char id[],
                            int airports_counter) {
    int i;
    for (i = 0; i < airports_counter; i++) {
        if (strcmp(airports_vector[i].id, id) == 0) {
            printf(ERR_DUPLICATE_AIRPORT);
            return 0;
        }
    }
    return 1;
}

static int check_errors_new_airport(Airport airports_vector[],
                                    int airports_counter, char id[]) {
    int status_id, status_2_many, status_duplicate;
    status_id = check_invalid_id(id);
    status_2_many = check_2_many(airports_counter);
    status_duplicate =
        check_duplicates(airports_vector, id, airports_counter);
    return (status_id && status_2_many && status_duplicate) ? 1 : 0;
}

int new_airport(Airport airports_vector[], int airports_counter) {
    char id[MAX_ID + 1];
    char country[MAX_COUNTRY + 1];
    char city[MAX_CITY + 1];
    scanf("%s %s %[^\n]s", id, country, city);

    if (check_errors_new_airport(airports_vector, airports_counter, id)) {
        add_airport_to_vector(id, country, city, airports_vector,
                              airports_counter);
        printf("airport %s\n", airports_vector[airports_counter].id);
        return 1;
    }
    return 0;
}
