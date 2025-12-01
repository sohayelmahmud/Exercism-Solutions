#!/usr/bin/env bash

main () {
    local first_row first_col second_row second_col deltx delty
    first_row=$(grep -oE "\-?[0-9]*," <<< "$2" | sed "s/,//")
    first_col=$(grep -oE ",\-?[0-9]*" <<< "$2" | sed "s/,//")
    second_row=$(grep -oE "\-?[0-9]*," <<< "$4" | sed "s/,//")
    second_col=$(grep -oE ",\-?[0-9]*" <<< "$4" | sed "s/,//")

    if [[ $first_row -lt 0 || $first_col -lt 0 || $second_row -lt 0 || $second_col -lt 0 ]]; then
        echo "row not positive and/or column not positive"
        exit 1
    elif [[ $first_row -gt 7 || $first_col -gt 7 || $second_row -gt 7 || $second_col -gt 7 ]]; then
        echo "row not on board and/or column not on board"
        exit 1
    elif [[ $first_row -eq $second_row && $first_col -eq $second_col ]]; then
        echo "same position"
        exit 1
    fi

    [[ $second_col -gt $first_col ]] && deltx=$((second_col-first_col)) || deltx=$((first_col-second_col))
    [[ $second_row -gt $first_row ]] && delty=$((second_row-first_row)) || delty=$((first_row-second_row))

    if [[ $deltx -eq $delty || $deltx -eq 0 || $delty -eq 0 ]]; then
        echo "true"
    else
        echo "false"
    fi
    exit 0
}

# call main with all of the positional arguments
main "$@"
