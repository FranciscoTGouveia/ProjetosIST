#include "actions.h"
#include <stdio.h>
#include <string.h>

Airport create_airport(char id[], char country[], char city[]) {
    Airport airport;
    strcpy(airport.id, id);
    strcpy(airport.country, country);
    strcpy(airport.city, city);
    return airport;
}

void print_new_airport(Airport airport) {
    printf("airport %s\n", airport.id);
}

void new_airport() {
    char id[MAX_ID + 1];
    char country[MAX_COUNTRY + 1];
    char city[MAX_CITY + 1];
    Airport new_airport;
    scanf("%s %s %[^\n]", id, country, city);
    new_airport = create_airport(id, country, city);
    print_new_airport(new_airport);
}
