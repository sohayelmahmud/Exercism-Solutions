#!/usr/bin/env bash

combo="$1"; shift; num=$(printf "%s\n" "$@" | sort | tr -d '\n')

declare -i f=${num:0:1} m=${num:2:1} l=${num:4:1}
declare -A cs=([ones]=1 [twos]=2 [threes]=3 [fours]=4 [fives]=5 [sixes]=6 [choice]=.)

score() { echo $(( $(echo "$num" | grep -o "$1" | paste -s -d '+' | bc) )); }

case $combo in
    "yacht")           echo $(( ($f   == $l)    * 50 )) ;;
    "big straight")    echo $(( ($num == 23456) * 30 )) ;;
    "little straight") echo $(( ($num == 12345) * 30 )) ;;
    "four of a kind") [[ $num =~ $m{4} ]] && echo $(( 4 * $m )) || echo 0 ;;
    "full house") [[ $num =~ ^$f{2,3}$l{2,3}$ && $f != $l ]] && score . || echo 0 ;;
    *) score "${cs[$combo]}" ;;
esac