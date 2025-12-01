#!/usr/bin/env bash
num=$1; counter=0
[ $num -lt 1 ] && { echo "Error: Only positive numbers are allowed" ; exit 1 ; }

while [ $num -ne 1 ]; do
    (( counter++ ))
    (( $num % 2 == 0 )) && (( num /= 2 )) || (( num = $num * 3 + 1 ))
done

echo $counter