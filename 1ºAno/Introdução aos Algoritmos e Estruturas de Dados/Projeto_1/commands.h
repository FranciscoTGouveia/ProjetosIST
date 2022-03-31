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
#define MAX_FLIGHTS 30000
#define MAX_DATE 10
#define MAX_TIME 5

/* Available commands keys */
#define QUIT_CMD 'q'
#define ADD_AIRPORT_CMD 'a'
#define LIST_AIRPORTS_CMD 'l'
#define ADD_FLIGHT_CMD 'v'
#define LIST_DEPARTURES_CMD 'p'
#define LIST_ARRIVALS_CMD 'c'
#define STEP_DATE_CMD 't'

/* User-Oriented messages */
#define ERR_INVALID_AIRPORT_ID "invalid airport ID\n"
#define ERR_TOO_MANY_AIRPORTS "too many airports\n"
#define ERR_DUPLICATE_AIRPORT "duplicate airport\n"
#define ERR_NO_SUCH_AIRPORT_ID "no such airport ID\n"
#define ERR_INVALID_FLIGHT_CODE "invalid flight code\n"
#define ERR_FLIGHT_ALREADY_EXISTS "flight already exists\n"
#define ERR_TOO_MANY_FLIGHTS "too many flights\n"
#define ERR_INVALID_DATE "invalid date\n"
#define ERR_INVALID_DURATION "invalid duration\n"
#define ERR_INVALID_CAPACITY "invalid capacity\n"

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
    int date;
    int time;
    int duration;
    int capacity;
} Flight;

/* "Add Airport" command functions: */
int new_airport(Airport airports_vector[], int airports_counter);
void sort_airports(Airport airports_vector[], int airports_counter);


/* "List" command function: */
void list_airports(Airport airports_vector[], int airports_counter,
                   Flight flight_vec[], int flight_count);


/* "Add Flight" command function: */
int new_flight(Airport air_vec[], int air_count, Flight flight_vec[],
               int flight_count, int date);
int binary_search(Airport air_vec[], char target[], int l, int r);


/* "List departures" command function */
void list_departures(Airport air_vec[], int air_count, Flight flight_vec[],
                     int flight_count);
void sort_flights(Flight flight_vec[], int flights_count);
int check_airport(Airport air_vec[], int air_count, char air_target[]);
void list_arrivals(Airport air_vec[], int air_count, Flight flight_vec[],
                   int flight_count);
int calculate_arrival_time(int arr_time);
int calculate_arrival_date(int arr_time, int date);


/* "Set time" command functions: */
int step_date(int last_date);
int check_date(int last_date, int new_date);
int date2int(int day, int month, int year);
int time2int(int hours, int minutes);
int same_day(int date, int day, int month, int year);
