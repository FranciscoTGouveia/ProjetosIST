#ifndef ACTIONS_H
#define ACTIONS_H

#define MAX_ID 3
#define MAX_COUNTRY 30
#define MAX_CITY 50

typedef struct {
    char id[MAX_ID + 1];
    char country[MAX_COUNTRY + 1];
    char city[MAX_CITY + 1];
} Airport;

/* "Add" command functions: */
void new_airport();

#endif
