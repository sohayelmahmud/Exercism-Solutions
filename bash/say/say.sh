#!/usr/bin/env bash

ONES=( zero one two three four five six seven eight nine )
TEEN=( ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen )
TENS=( twenty thirty forty fifty sixty seventy eighty ninety )
THOU=( hundred thousand million billion )

(( $1 < 0 || $1 > 999999999999 )) && { echo "input out of range" >&2; exit 1; }
(( $1 == 0 )) && { echo -n "${ONES[0]}"; exit; }

function say_1000 { local D="$1"
  read -d '\n' -ra N < <(fold -w1 <<< "$D"); shift
  if (( N[0] + N[1] + N[2] + $# == 0 )); then echo -n ""
  elif (( N[0] + N[1] + N[2] == 0 )); then say_1000 "$@"
  elif (( $# > 0 )); then echo -n "$(say_eng "${N[@]}") ${THOU[$#]} $(say_1000 "$@")"
  else say_eng "${N[@]}"; fi
}
function say_eng {
  if (( $# == 2 )); then
    if (( $1 + $2 == 0 )); then echo -n ""
    elif (( $1 == 0 )); then echo -n "${ONES[$2]}"
    elif (( $1 == 1 )); then echo -n "${TEEN[$2]}"
    elif (( $2 == 0 )); then echo -n "${TENS[$(( $1 - 2 ))]}"
    else echo -n "${TENS[$(( $1 - 2 ))]}-$(say_eng "$2")"; fi
  elif (( $# == 3 )); then
    if (( $1 == 0 )); then say_eng "$2" "$3"
    else echo -n "$(say_eng "$1") ${THOU[0]} $(say_eng "$2" "$3")"; fi
  else echo -n "${ONES[$1]}"; fi
}

function split_by_1000 { local N="$1"
  while (( ${#N} % 3 > 0 )); do N="0$N"; done; fold -w3 <<< "$N"
}

read -d '\n' -ra N < <(split_by_1000 "$1"); say_1000 "${N[@]}" | xargs
