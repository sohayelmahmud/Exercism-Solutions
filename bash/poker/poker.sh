#!/usr/bin/env bash

value() {
    case $1 in
    [2-9]) echo "$1" ;;
    10) echo a ;;
    J) echo b ;;
    Q) echo c ;;
    K) echo d ;;
    A) echo e ;;
    esac
}

declare -A ranks

for hand; do
    declare -A values=()
    declare -A suits=()

    for card in $hand; do
        value=$(value "${card%?}")
        ((values[$value]++))
        suit=${card: -1}
        ((suits[$suit]++))
    done

    ((flush = ${#suits[@]} == 1))

    declare -A combinations=()

    for i in {1..4}; do
        for j in {e..a} {9..1}; do
            [[ ${values[$j]} == "$i" ]] && combinations[$i]+="$j"
        done
    done

    if ((${#combinations[1]} == 5)); then
        [[ ${combinations[1]} == e5432 ]] && combinations[1]=54321
        [[ edcba987654321 == *${combinations[1]}* ]] && straight=1 || straight=0
    fi

    if ((flush && straight)); then
        rank="9${combinations[1]}"
    elif ((flush)); then
        rank="6${combinations[1]}"
    elif ((straight)); then
        rank="5${combinations[1]}"
    elif [[ ${combinations[4]} ]]; then
        rank="8${combinations[4]}${combinations[1]}"
    elif [[ ${combinations[3]} ]]; then
        [[ ${combinations[2]} ]] &&
            rank="7${combinations[3]}${combinations[2]}" ||
            rank="4${combinations[3]}${combinations[1]}"
    elif [[ ${combinations[2]} ]]; then
        ((${#combinations[2]} == 2)) &&
            rank="3${combinations[2]}${combinations[1]}" ||
            rank="2${combinations[2]}${combinations[1]}"
    else
        rank="1${combinations[1]}"
    fi

    ranks[$rank]+="$hand\n"
done

for k in "${!ranks[@]}"; do
    [[ $k > $max ]] && max=$k
done

echo -en "${ranks[$max]}"
