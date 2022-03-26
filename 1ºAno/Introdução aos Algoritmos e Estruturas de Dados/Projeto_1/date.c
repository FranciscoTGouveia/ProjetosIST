#include "commands.h"
#include <stdio.h>

/* Date is stored in a single bit:
    1ºbit: day
    2ºbit: month
    3º and 4º bits: year
*/

int time2int(int hours, int minutes) { return (hours * 60) + minutes; }

static int check_date(int last_date, int new_date) {
    /* When transformed to an int, a 1 year difference is 65536 */
    if (new_date < last_date || (new_date - last_date) > 65536) {
        return 0;
    }
    return 1;
}

int step_date(int last_date) {
    int day, month, year, new_date;
    scanf("%d-%d-%d", &day, &month, &year);
    new_date = date2int(day, month, year);

    if (check_date(last_date, new_date)) {
        printf("%02d-%02d-%02d\n", day, month, year);
        return new_date;
    } else {
        printf(ERR_INVALID_DATE);
        return last_date;
    }
}

int date2int(int day, int month, int year) {
    int date = 0;
    date |= (day & 0xff);
    date |= (month & 0xff) << 8;
    date |= (year & 0xffff) << 16;

    return date;
}
