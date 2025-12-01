#!/usr/bin/env bash

abilities=(
    "strength"
    "dexterity"
    "constitution"
    "intelligence"
    "wisdom"
    "charisma"
)


consmodifier() {
    local constitution="$1"
    consMinus=$(( constitution - 10 ))
    if [[ consMinus -lt 0 ]]; then
        (( consMinus-= 1 ))
    fi
    consmod=$(( consMinus / 2 ))
    echo "$consmod"
}

if [[ "$1" == "generate" ]]; then
    RANDOM=$$
    for (( i=0 ; i < 6 ; i++ )); do
        sum=0
        for (( a=0 ; a < 3 ; a++ )); do
            num=$(echo 1 + $RANDOM % 6 | bc)
            (( sum+=num ))
        done
        echo "${abilities[i]} $sum"
        if [[ $i -eq 2 ]]; then
            constitution="$sum"
        fi
    done
    cm=$(consmodifier "$constitution")
    echo "hitpoints $(( cm + 10 ))"
elif [[ "$1" == "modifier" ]]; then
    constitution="$2"
    cm=$(consmodifier "$constitution")
    echo "$cm"
fi
