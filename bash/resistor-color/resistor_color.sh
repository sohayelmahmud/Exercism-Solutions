#!/usr/bin/env bash

declare -A colors

colors["black"]=0
colors["brown"]=1
colors["red"]=2
colors["orange"]=3
colors["yellow"]=4
colors["green"]=5
colors["blue"]=6
colors["violet"]=7
colors["grey"]=8
colors["white"]=9

#Gli array associativi in bash non mantengono l'ordiine delle chiavi :(

ordered_keys=("black" "brown" "red" "orange" "yellow" "green" "blue" "violet" "grey" "white")

if [[ "$1" =~ code ]] ; then
    echo ${colors[$2]}
elif [[ "$1" =~ colors ]] ; then
    for color in "${ordered_keys[@]}"; do
        echo "$color"
    done
fi