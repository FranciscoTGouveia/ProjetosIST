#include <stdio.h>
#include "actions.h"

/*typedef struct {
    char id;
    int country;
    int city;
} Airport;*/

Airport *new_airport(char id, int country, int city) {
    Airport airport;
    Airport *pnt2airport = &airport;
    airport.id = id;
    airport.city = country;
    airport.country = city;
    return pnt2airport;
}

void print_new_airport(Airport *airport) {
    printf("airport %c\n", airport->id);
}
