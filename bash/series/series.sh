#!/usr/bin/env bash

error() {
  echo "$1"
  exit 1
}

series=$1
slice=$2

[[ $slice -eq 0 ]]            && error "slice length cannot be zero"
[[ $slice -lt 0 ]]            && error "slice length cannot be negative"
[[ $series -eq "" ]]          && error "series cannot be empty"
[[ $slice -gt "${#series}" ]] && error "slice length cannot be greater than series length"

for (( i = 0; i <= ${#series}-slice; i++ )); do
  result[i]="${series:i:slice}"
done

echo "${result[@]}"
