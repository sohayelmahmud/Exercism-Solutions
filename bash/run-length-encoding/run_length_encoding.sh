#!/usr/bin/env bash

encode() {
    local pt=$1
    while [[ -n $pt ]]; do
        [[ $pt =~ (${pt:0:1}+)(.*) ]]
        (( ${#BASH_REMATCH[1]} > 1 )) && ct+=${#BASH_REMATCH[1]}
        ct+=${pt:0:1}
        pt=${BASH_REMATCH[2]}
    done
    echo "$ct"
}

decode() {
    local ct=$1
    while [[ -n $ct ]]; do
        [[ $ct =~ ([0-9]+)?([a-zA-Z ])(.*) ]]
        pt+=$(printf "%0.s${BASH_REMATCH[2]}" $(seq 1 ${BASH_REMATCH[1]}))
        ct=${BASH_REMATCH[3]}
    done
    echo "$pt"
}

$1 "$2"