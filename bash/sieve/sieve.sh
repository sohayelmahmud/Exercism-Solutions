#!/usr/bin/env bash

main () {
    #empty echo if number <= 1
    [[ $1 -le 1 ]] && echo "" && exit 0

    #add 2 to out since our for loops wouldn't catch it
    out="2 "

    #test if any number `i` between 2 and $1 is evenly divisible by
    #any number `j` between 2 and $1-1 (don't want to test division on itself)
    #if we find a combination where it is evenly divisible, stop testing $i, break, go next
    #since we are not testing division by 1 or itself, when tests reach $i-1
    #and $i%$j != 0, we tested all numbers and found our prime number, append $i to out
    for i in $(seq 2 $1); do
        for j in $(seq 2 $((i-1))); do
            [[ $(($i%$j)) -eq 0 ]] && break
            [[ $j == $((i-1)) ]] && out+="$i "
        done
    done
    echo $out
}
main "$@"
