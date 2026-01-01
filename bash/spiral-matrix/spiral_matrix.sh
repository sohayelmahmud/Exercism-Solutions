#!/usr/bin/env bash

main () {
    len=$1
    direction=( 1 "$1" -1 $(( -$1 )) )
    x=0
    position=0
    len_help=$len

    declare -a output
    for (( idx=1; idx<=$1**2; idx++ )); do
        if (( len_help == 0 )); then
            (( x % 2 == 0 )) && (( len -= 1 ))
            len_help=$len
            (( x = (x + 1) % 4 ))
        fi
        position=$(( position + direction[x] ))
        output[position]=$idx
        (( len_help -= 1 ))
    done

    for (( i=0; i<$1; i++ )); do
        (( i != 0 )) && pos=$(( i * $1 + 1 ))
        echo "${output[@]:pos:$1}"
    done
}

main "$@"