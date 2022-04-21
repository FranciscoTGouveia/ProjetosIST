#!/bin/bash

# Compile the program
gcc -ansi -pedantic -Wall -Wextra -Wall -p -o main main.c add.c listAirports.c flight.c date.c listDepartures.c listArrivals.c reservation.c cleaning.c aux.c

cd tests/ || exit
# Pass the tests to the algorithm
mkdir eheh
for test in *.in
do
	finaltest=$(echo $test | cut -c1-6)	
	../main < "$test" > eheh/"$finaltest".out
done

# Compare the tests to the Solved_Tests
for out in *.out
do
    if cmp -s "$out" "./eheh/$out"
    then 
        echo -e "\e[1;32m☑ Test $out Passed !\e[0m"
    else
        echo -e "\e[1;31m☒ Test $out Failed !\e[0m"
    fi
done

# Remove clutter
rm eheh/ -R
