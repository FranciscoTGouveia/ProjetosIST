#include "commands.h"
#include <stdio.h>

/* Date is stored in a single byte:
    1ºbyte: day
    2ºbyte: month
    3º and 4º bytes: year
*/

int time2int(int hours, int minutes) { return (hours * 60) + minutes; }

int same_day(int date, int day, int month, int year) {
    /*  */
    int date_day = (date & 0xff);
    int date_month = ((date >> 8) & 0xff);
    int date_year = ((date >> 16) & 0xffff);
    if (date_day == day && date_month == month && date_year == year) {
        return 1;
    }
    return 0;
}

int check_date(int last_date, int new_date) {
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

static int number_in_vector(int num_vec[], int num_count, int target) {
    int i;
    for (i = 0; i < num_count; i++) {
        if (num_vec[i] == target) return 1;
    }
    return 0;
}

static int advance1day(int date) {
    int day = (date & 0xff);
    int month = ((date >> 8) & 0xff);
    int year = ((date >> 16) & 0xffff);
    int months31[7] = {1, 3, 5, 7, 8, 10, 12};
    if (month == 12 && day == 31) {
        date = date2int(1, 1, year + 1);
    } else if (number_in_vector(months31, 7, month)) {
        date = (day < 31) ? date2int(day + 1, month, year)
                          : date2int(1, month + 1, year);

    } else if (month == 2) {
        date = (day < 28) ? date2int(day + 1, month, year)
                          : date2int(1, month + 1, year);

    } else {
        date = (day < 30) ? date2int(day + 1, month, year)
                          : date2int(1, month + 1, year);
    }

    return date;
}

int calculate_arrival_time(int arr_time) {
    int new_hour, new_min;
    if (((arr_time / 60) - 24) >= 0) {
        new_hour = (arr_time / 60) - 24;
        new_min = arr_time % 60;
        arr_time = time2int(new_hour, new_min);
    }
    return arr_time;
}

int calculate_arrival_date(int arr_time, int date) {
    if (((arr_time / 60) - 24) >= 0) {
        date = advance1day(date);
    }
    return date;
}
