#!/usr/bin/env bash

readonly ORDINALS=(first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth)

readonly GIFTS=(
    "a Partridge in a Pear Tree."
    "two Turtle Doves, and "
    "three French Hens, "
    "four Calling Birds, "
    "five Gold Rings, "
    "six Geese-a-Laying, "
    "seven Swans-a-Swimming, "
    "eight Maids-a-Milking, "
    "nine Ladies Dancing, "
    "ten Lords-a-Leaping, "
    "eleven Pipers Piping, "
    "twelve Drummers Drumming, "
)

for ((i = 1; i <= $2; i++)); do
    gifts="${GIFTS[i - 1]}$gifts"
    ((i >= $1)) && echo "On the ${ORDINALS[i - 1]} day of Christmas my true love gave to me: $gifts"
done
