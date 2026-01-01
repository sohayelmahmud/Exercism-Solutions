#!/usr/bin/env bash

target=$1

# build array from params
arr=()
for ((i=1; i < $#; i++)); do
  (( index=$i-1 ))
  arr[$index]=${@:$i+1:1}
done

# validate arg count
(( $# < 2 )) && { echo "-1"; exit 0; }

min=0
(( max=${#arr[@]}-1 ))

while (( "$min" <= "$max" )); do
  # get midpoint
  (( mid=($min+$max)/2 ))

  # if hit target
  (( ${arr[$mid]} == $target )) && {
    (( offset=$mid-1 ))
    echo "$mid"
    exit 0
  }
  if (( ${arr[$mid]} > $target )); then
    (( max=$mid-1 ))
  else (( min=$mid+1 ))
  fi
done

# not found in list
echo "-1"