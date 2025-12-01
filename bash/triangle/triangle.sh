#!/bin/bash

function triangle() {
    if (( $(echo "$1 <= 0" | bc) )) || \
       (( $(echo "$2 <= 0" | bc) )) || \
       (( $(echo "$3 <= 0" | bc) )) || \
       (( $(echo "$1 + $2 <= $3" | bc) )) || \
       (( $(echo "$2 + $3 <= $1" | bc) )) || \
       (( $(echo "$1 + $3 <= $2" | bc) ))
    then
        echo 'false'
    elif (( $(echo "$1 == $2" | bc) )) && \
         (( $(echo "$2 == $3" | bc) ))
    then
        echo 'equilateral'
    elif (( $(echo "$1 == $2" | bc) )) || \
         (( $(echo "$2 == $3" | bc) )) || \
         (( $(echo "$1 == $3" | bc) ))
    then
        echo 'isosceles'
    else
        echo 'scalene'
    fi
}

result=$(triangle $2 $3 $4)

if [[ "$1" == $result ]] || \
   ([[ "$1" == "isosceles" ]] && [[ $result == "equilateral" ]])
then
    echo 'true'
else
    echo 'false'
fi
