#!/usr/bin/env bash

function change { local i j THIS
  for (( i = 0; i < "${#COINS[@]}"; i++ )); do (( COINS[i] > $1 )) && break
    (( j = $1 - COINS[i], THIS = MIN[j] + 1 ))
    (( THIS < MIN[$1] )) && (( MIN[$1] = THIS, CHANGE[$1] = COINS[i] ))
  done
}

MIN=(0) CHANGE=() TOTAL="$1"; shift; read -ra COINS <<< "$@"

(( TOTAL == 0 )) && { echo; exit; }
(( TOTAL < 0 )) && { echo "target can't be negative" >&2; exit 1; }
(( COINS[0] > TOTAL )) && { echo "can't make target with given coins" >&2; exit 1; }

for (( i = 1; i <= TOTAL; i++ )) do MIN[i]="$(( TOTAL + 1 ))"; change "$i"; done

(( MIN[-1] > TOTAL )) && { echo "can't make target with given coins" >&2; exit 1; }

while (( TOTAL > 0 )); do echo "${CHANGE[$TOTAL]}"; (( TOTAL -= CHANGE[TOTAL] ))
done | sort -n | tr '\n' ' ' | xargs
