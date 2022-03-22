#include <stdio.h>
#include "actions.h"

int main() {
    char action;
    Airport airports_vector[MAX_AIRPORTS];
    int airports_counter = 0;

    while ((action = getchar()) != EOF) {
        switch (action) {
            case 'q': {
                return 0;
            }
            case 'a': {
                if (new_airport(airports_vector, airports_counter)) {
                    airports_counter++;
                }
                break;
            }
            case 'l':
                return 0;
            case 'v':
                return 0;
            case 'p':
                return 0;
            case 'c':
                return 0;
            case 't':
                return 0;
        }
        action = getchar();
    }
    return 0;
}
