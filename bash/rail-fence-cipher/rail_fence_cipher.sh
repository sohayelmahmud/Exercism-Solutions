#!/usr/bin/env bash

die() {
    echo "$1" 1>&2
    exit 1
}

(($# == 0)) && die 'no options'
(($2 == 0)) && die 'zero rails'
(($2 < 0)) && die 'negative rails'

if [[ $1 == -e ]]; then
    i=0
    down=1

    while IFS= read -rn 1 character; do
        rails[i]+=$character
        ((down == 1 ? i++ : i--))
        ((i % ($2 - 1) == 0)) && ((down ^= 1))
    done < <(echo -n "$3")

    IFS=
    echo "${rails[*]}"
elif [[ $1 == -d ]]; then
    declare -A rails

    length=${#3}

    i=0
    down=1

    for ((j = 0; j < length; j++)); do
        rails[$i, $j]=-1
        ((down == 1 ? i++ : i--))
        ((i % ($2 - 1) == 0)) && ((down ^= 1))
    done

    index=0

    for ((i = 0; i < $2; i++)); do
        for ((j = 0; j < length; j++)); do
            if [[ ${rails[$i, $j]} == -1 ]] && ((index < length)); then
                rails[$i, $j]=${3:index:1}
                ((index++))
            fi
        done
    done

    i=0
    down=1

    for ((j = 0; j < length; j++)); do
        result+=${rails[$i, $j]}
        ((down == 1 ? i++ : i--))
        ((i % ($2 - 1) == 0)) && ((down ^= 1))
    done

    echo "$result"
fi
