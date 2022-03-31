#include "commands.h"

static void add_airport_to_vector(char id[], char country[], char city[],
                                  Airport air_vec[], int air_count) {
    /* Add new airport to airports vector */
    strcpy(air_vec[air_count].id, id);
    strcpy(air_vec[air_count].country, country);
    strcpy(air_vec[air_count].city, city);
}

static int check_invalid_id(char id[]) {
    /* Check if an ID is valid (all upper letters) */
    int i;
    for (i = 0; i < MAX_ID; i++) {
        if (!isupper(id[i])) {
            printf(ERR_INVALID_AIRPORT_ID);
            return 0;
        }
    }
    return 1;
}

static int check_2_many_airports(int air_count) {
    /* Check if the new airport will not exceed the limit */
    if (air_count >= MAX_AIRPORTS) printf(ERR_TOO_MANY_AIRPORTS);
    return (air_count < MAX_AIRPORTS);
}

static int check_duplicates(Airport air_vec[], char id[], int air_count) {
    /* Check if there isn't already an airport with the same ID */
    int i;
    for (i = 0; i < air_count; i++) {
        if (strcmp(air_vec[i].id, id) == 0) {
            printf(ERR_DUPLICATE_AIRPORT);
            return 0;
        }
    }
    return 1;
}

static int check_errors_new_airport(Airport air_vec[], int air_count,
                                    char id[]) {
    /* Agreggate all error-checking in a single function */
    return (check_invalid_id(id) && check_2_many_airports(air_count) &&
            check_duplicates(air_vec, id, air_count));
}

void sort_airports(Airport air_vec[], int vec_size) {
    /* Sort airports by ID (insertion sort) */
    int i, j;
    Airport temp;
    for (i = 1; i < vec_size; i++) {
        temp = air_vec[i];
        j = i - 1;
        while (j >= 0 && strcmp(air_vec[j].id, temp.id) > 0) {
            air_vec[j + 1] = air_vec[j];
            j--;
        }
        air_vec[j + 1] = temp;
    }
}

int new_airport(Airport air_vec[], int *air_count) {
    char id[MAX_ID + 1];
    char country[MAX_COUNTRY + 1];
    char city[MAX_CITY + 1];
    scanf("%s %s %[^\n]s", id, country, city);
    /* Check errors and add airport to airports vector */
    if (check_errors_new_airport(air_vec, *air_count, id)) {
        add_airport_to_vector(id, country, city, air_vec, *air_count);
        printf("airport %s\n", air_vec[*air_count].id);
        (*air_count)++;
        sort_airports(air_vec, *air_count);
        return 1;
    }
    return 0;
}
