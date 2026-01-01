#!/usr/bin/env bash

declare -A dictionary
dictionary[" _ | ||_|   "]=0
dictionary["     |  |   "]=1
dictionary[" _  _||_    "]=2
dictionary[" _  _| _|   "]=3
dictionary["   |_|  |   "]=4
dictionary[" _ |_  _|   "]=5
dictionary[" _ |_ |_|   "]=6
dictionary[" _   |  |   "]=7
dictionary[" _ |_||_|   "]=8
dictionary[" _ |_| _|   "]=9

[ -t 0 ] && exit

readarray -t lines

(( ${#lines[@]} % 4 != 0 )) && echo "Number of input lines is not a multiple of four" >&2 && exit 1

for (( k = 0; k < ${#lines[@]} / 4; k++ )); do
    (( k > 0 )) && echo -n ','

    ocr_numbers=()
    for line in "${lines[@]:4 * k:4}"; do
        (( ${#line} % 3 != 0 )) && echo "Number of input columns is not a multiple of three" >&2 && exit 1

        for (( i = 0; i < ${#line}; i += 3 )); do
            ocr_numbers[i / 3]+=${line:i:3}
        done
    done

    for num in "${ocr_numbers[@]}"; do
        echo -n "${dictionary["$num"]:-?}"
    done
done
