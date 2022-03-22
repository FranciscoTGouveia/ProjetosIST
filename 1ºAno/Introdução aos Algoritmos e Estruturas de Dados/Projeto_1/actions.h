#ifndef ACTIONS_H
#define ACTIONS_H

#define MAX_ID 3
#define MAX_COUNTRY 30
#define MAX_CITY 50
#define MAX_AIRPORTS 40

typedef struct {
    char id[MAX_ID + 1];
    char country[MAX_COUNTRY + 1];
    char city[MAX_CITY + 1];
} Airport;

/* "Add" command functions: */
int new_airport();

#endif
