#!/usr/bin/env bash

declare -A error_message=(
  [incomplete]="Score cannot be taken until the end of the game"
  [negative]="Negative roll is invalid"
  [exceeds]="Pin count exceeds pins on the lane"
  [game_over]="Cannot roll after game is over"
)

exit_error() {
  echo "${error_message[$1]:-$1}" >&2; exit 1
}

validate_rolls() {
  for roll in "$@"; do
    [[ -z "$roll" ]] && exit_error incomplete
    (( roll < 0 )) && exit_error negative
    (( roll > 10 )) && exit_error exceeds
  done
}

main() {
  local frame score=0
  for frame in {1..10}; do
    validate_rolls "$1" "$2"
    (( score += $1 + $2 ))
    if (( $1 == 10 || $1 + $2 == 10 )); then
      validate_rolls "$3"
      (( score += "$3" ))
      (( $1 == 10 && frame == 10 && $2 != 10 && $2 + $3 > 10 )) && exit_error exceeds
    elif (( $1 + $2 < 10 )); then shift 2; continue
    else exit_error exceeds
    fi
    shift $(( frame == 10 ? 3 : 2 - ($1 == 10) ))
  done
  (( $# > 0 )) && exit_error game_over
  echo "$score"
}

main "$@"