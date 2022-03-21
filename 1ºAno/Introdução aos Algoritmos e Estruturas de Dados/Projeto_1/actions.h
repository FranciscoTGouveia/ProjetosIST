#ifndef ACTIONS_H
#define ACTIONS_H

typedef struct {
    char id;
    int country;
    int city;
} Airport;

/* "Add" command functions: */
Airport *new_airport(char id, int country, int city);
void print_new_airport(Airport *airport);

#endif
