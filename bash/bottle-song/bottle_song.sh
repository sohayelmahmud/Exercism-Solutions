#!/usr/bin/env bash

# Input validation
if [[ $# -ne 2 ]]; then
  echo "Error: 2 arguments expected - starting number of bottles and number of verses." >&2
  exit 1
fi

start=$1
count=$2

# Validate arguments
if ! [[ "$start" =~ ^[0-9]+$ && "$count" =~ ^[0-9]+$ ]]; then
  echo "Error: both arguments must be positive integers." >&2
  exit 1
fi

if (( count > start )); then
  echo "Error: cannot generate more verses than bottles." >&2
  exit 1
fi

# Convert numbers to lowercase words (1-10)
num_to_word() {
  case $1 in
    0) echo "no" ;;
    1) echo "one" ;;
    2) echo "two" ;;
    3) echo "three" ;;
    4) echo "four" ;;
    5) echo "five" ;;
    6) echo "six" ;;
    7) echo "seven" ;;
    8) echo "eight" ;;
    9) echo "nine" ;;
    10) echo "ten" ;;
  esac
}

# Capitalize first letter
capitalize() {
  local input="$1"
  echo "${input^}"
}

# Build bottle phrase with correct pluralization
bottle_phrase() {
  local num=$1
  local word
  word=$(num_to_word "$num") || return 1
  if (( num == 1 )); then
    echo "$(capitalize "$word") green bottle"
  elif (( num == 0 )); then
    echo "no green bottles"
  else
    echo "$(capitalize "$word") green bottles"
  fi
}

# Verse generation loop
for (( i = start; i > start - count; i-- )); do
  this_bottle=$(bottle_phrase "$i")
  next_count=$((i - 1))

  # Special lowercase handling for last line
  if (( next_count == 1 )); then
    next_line="one green bottle"
  elif (( next_count == 0 )); then
    next_line="no green bottles"
  else
    next_line="$(num_to_word "$next_count") green bottles"
  fi

  echo "$this_bottle hanging on the wall,"
  echo "$this_bottle hanging on the wall,"
  echo "And if one green bottle should accidentally fall,"
  echo "There'll be $next_line hanging on the wall."

  # Add blank line unless it's the last verse
  if (( i > start - count + 1 )); then
    echo
  fi
done
