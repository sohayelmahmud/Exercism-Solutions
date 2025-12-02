#!/usr/bin/env bash

findallwords() {
    local line linelen PATTERN=$'^[0-9]+|^[a-zA-Z]+(\'[a-zA-Z]+)?'
    local -i lineno=0 charno=0
    while read line; do
        linelen=${#line}
        while ((charno < linelen)); do
            if [[ "${line:charno}" =~ $PATTERN ]]; then
                echo "${BASH_REMATCH[0]}"
                charno+=${#BASH_REMATCH[0]}
            else
                charno+=1
            fi
        done
        charno=0
        lineno+=1
    done
}

tolower() {
    local line
    while read line; do
        echo "${line,,}"
    done
}

count() {
    local line word
    local -iA counts
    while read line; do
        counts[$line]+=1
    done
    for word in "${!counts[@]}"; do
        printf '%s: %d\n' "$word" "${counts[$word]}"
    done
}

main() {
    printf '%b\n' "$1" | findallwords | tolower | count
}

main "$@"
