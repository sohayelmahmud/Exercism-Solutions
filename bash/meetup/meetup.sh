#!/usr/bin/env bash

main() {
    year="$1"
    month="$2"
    day="$4"

    case "$3" in
        first ) week=1;;
        second) week=2;;
        third ) week=3;;
        fourth) week=4;;
        last  ) week="$";;
        teenth) week="/1[3-9]$/";;
    esac

    for i in {1..31}; do
        date -d "$year-$month-$i" +'%F %A' 2>/dev/null
    done |
    grep "$day" |
    cut -d ' ' -f 1 |
    sed -n -e "${week}p"
}

main "$@"