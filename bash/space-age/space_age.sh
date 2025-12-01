#!/usr/bin/env bash

seconds_per_earth_year=31557600
declare -A planets_year
planets_year=(
    ["Mercury"]="0.2408467"
    ["Venus"]="0.61519726"
    ["Earth"]="1.0"
    ["Mars"]="1.8808158"
    ["Jupiter"]="11.862615"
    ["Saturn"]="29.447498"
    ["Uranus"]="84.016846"
    ["Neptune"]="164.79132"
)

if [ ${planets_year[$1]+_} ]; then
    printf "%.2f\n" $(awk "BEGIN {print $2/$seconds_per_earth_year/${planets_year[$1]}}")
    exit 0
fi

echo "not a planet"
exit 1