#!/usr/bin/env bash

write_digit () {
    local -i digit="$1"
    local one_sym="$2"
    local five_sym="$3"
    local ten_sym="$4"
    if (( digit <= 3 )); then
        for (( i = 1; i <= digit; i++ )); do
            echo -n "$one_sym"
        done
    elif (( digit == 4 )); then
        echo -n "$one_sym$five_sym"
    elif (( digit <= 8 )); then
        echo -n "$five_sym"
        for (( i = 6; i <= digit; i++ )); do
            echo -n "$one_sym"
        done
    else
        echo -n "$one_sym$ten_sym"
    fi
}

romanize () {
    local -i number="$1"
    local -i digit
    (( digit = number / 1000 ))
    (( number = number - 1000 * digit ))
    write_digit "$digit" "M" "M" "M"
    (( digit = number / 100 ))
    (( number = number - 100 * digit ))
    write_digit "$digit" "C" "D" "M"
    (( digit = number / 10 ))
    (( number = number - 10 * digit ))
    write_digit "$digit" "X" "L" "C"
    write_digit "$number" "I" "V" "X"
}

romanize "$1"
