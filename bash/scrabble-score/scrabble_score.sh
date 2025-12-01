#!/usr/bin/env bash

function letter_value() {
    case "$1" in
    [aeioulnrst]) echo 1 ;;
    [dg]) echo 2 ;;
    [bcmp]) echo 3 ;;
    [fhvwy]) echo 4 ;;
    [k]) echo 5 ;;
    [jx]) echo 8 ;;
    [qz]) echo 10 ;;
    *) echo 0 ;;
    esac
}

str="${1,,}"
score=0

for ((i = 0; i < "${#str}"; i++)); do
    value=$(letter_value "${str:i:1}")
    ((score += value))
done

echo "$score"
