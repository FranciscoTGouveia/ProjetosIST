#ifndef COMMANDS_H
#define COMMANDS_H

/* Include Standart Libraries */
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

/* Type related constants */
/* Airport related */
#define MAX_ID 3
#define MAX_COUNTRY 30
#define MAX_CITY 50
#define MAX_AIRPORTS 40
/* Flight related */
#define MAX_FLIGHT_CODE 6

/* Available commands keys */
#define QUIT_CMD 'q'
#define ADD_AIRPORT_CMD 'a'
#define LIST_AIRPORTS_CMD 'l'
#define ADD_FLIGHT_CMD 'v'
#define LIST_DEPARTURES_CMD 'p'
#define LIST_ARRIVALS_CMD 'c'
#define STEP_TIME_CMD 't'

/* User-Oriented messages */
#define ERR_INVALID_AIRPORT_ID "invalid airport ID\n"
#define ERR_TOO_MANY_AIRPORTS "too many airports\n"
#define ERR_DUPLICATE_AIRPORT "duplicate airport\n"
#define ERR_NO_SUCH_AIRPORT_ID "no such airport ID\n"

/* Custom Types (Structures) */
typedef struct {
    char id[MAX_ID + 1];
    char country[MAX_COUNTRY + 1];
    char city[MAX_CITY + 1];
} Airport;

typedef struct {
    char flight_code[MAX_FLIGHT_CODE + 1];
    char id_departure[MAX_ID + 1];
    char id_arrival[MAX_ID + 1];
    /* data: */
    short duration;
    short capacity;
} Flight;

/* "Add" command function: */
int new_airport(Airport airports_vector[], int airports_counter);

/* "List" command function */
int list_airports();

#endif
