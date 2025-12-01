#!/usr/bin/env bash
###
# Base Tests
###
# Check to make sure no empty arguments
(( $# == 1 )) || exit 1

###
# Variables
###
# Set number to the first argument
# Set the main count
# Initialize the results variable
number=$1
count=2

###
# While Loop
###
# Run a while loop over the input
# Run another while loop to find the ones that are evenly divisible
# If so, add it to results
while (( number > 1 )); do
    while (( number % count == 0 )); do
        results+=( $count )
        (( number = number / count ))
    done
    (( count == 2 && (count+=1) || (count+=2) ))
done

echo "${results[@]}"