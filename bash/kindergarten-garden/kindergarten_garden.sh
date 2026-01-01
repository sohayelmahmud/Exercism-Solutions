#!/usr/bin/env bash

declare -A plants=([G]=grass [C]=clover [R]=radishes [V]=violets)

garden=( $(IFS=$'\n'; echo $1) )

first_letters=({A..L})
for index in "${!first_letters[@]}"; do
  [[ $2 == "${first_letters[index]}"* ]] && break
done
((garden_index = index * 2))

result=(
  "${plants[${garden[0]:garden_index:1}]}"
  "${plants[${garden[0]:garden_index+1:1}]}"
  "${plants[${garden[1]:garden_index:1}]}"
  "${plants[${garden[1]:garden_index+1:1}]}"
)

echo "${result[@]}"
