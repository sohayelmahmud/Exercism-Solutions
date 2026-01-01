#!/usr/bin/env bash

N=$1

if [ -z "$N" ]; then
  echo "Usage: $0 <number>"
  exit 1
fi

# Iterate over possible values of a
for ((a=1; a<N/3; a++)); do
  # Iterate over possible values of b
  for ((b=a+1; b<N/2; b++)); do
    # Calculate c
    c=$((N - a - b))
    # Check if a² + b² = c²
    if [ $((a*a + b*b)) -eq $((c*c)) ]; then
      echo "$a,$b,$c"
      found=1
    fi
  done
done