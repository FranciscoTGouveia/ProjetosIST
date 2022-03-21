#include <stdio.h>
#include "actions.h"

int main() {
    char action;
    while ((action = getchar()) != EOF) {
        switch (action) {
            case 'q': {
                return 0;
            }
            case 'a': {
                new_airport();
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
