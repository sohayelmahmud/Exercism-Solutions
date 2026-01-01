#!/usr/bin/env bash

declare -A win=() loss=() draw=() points=() matches=()

(( $# > 0 )) && exec < "$1"
while IFS=';' read -r a b outcome ; do
  [[ $a && $b ]] || continue
  (( matches[$a]++ )) || teams+=( "$a" )
  (( matches[$b]++ )) || teams+=( "$b" )
  case $outcome in
    (win) (( win[$a]++, loss[$b]++, points[$a] += 3 )) ;;
    (loss) (( win[$b]++, loss[$a]++, points[$b] += 3 )) ;;
    (draw) (( draw[$a]++, draw[$b]++, points[$a] += 1, points[$b] += 1 )) ;;
  esac
done

printf 'Team                           | MP |  W |  D |  L |  P\n'

for team in "${teams[@]}" ; do
  printf '%s%*s | %2d | %2d | %2d | %2d | %2d\n' \
      "$team" \
      "$(( 30 - ${#team} ))" "" \
      "${matches[$team]}" \
      "${win[$team]}" \
      "${draw[$team]}" \
      "${loss[$team]}" \
      "${points[$team]}"
done | sort -t'|' -k6,6nr -k1,1
