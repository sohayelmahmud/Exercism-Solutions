
#!/usr/bin/env bash

(( $2 <= $3 )) || { echo "min must be <= max" >&2; exit 1; }
if [[ "$1" = "smallest" ]]; then INC=1 P0="$2" P1="$3"
elif [[ "$1" = "largest" ]]; then INC="-1" P0="$3" P1="$2"
else echo "first arg should be 'smallest' or 'largest'" >&2; exit 1; fi

PALINDROME=0 FACTORS=
for (( Pi = P0; Pi != P1 + INC; Pi += INC )); do
  for (( Pj = P0; Pj != Pi + INC; Pj += INC )); do (( PROD = Pi * Pj ))
    for (( i = 0, j = ${#PROD} - 1; i < j; i++, j-- ))
      do (( ${PROD:i:1} == ${PROD:j:1} )) || continue 2; done
    if (( INC > 0 )); then PALINDROME="$PROD"; [[ -z "$FACTORS" ]] &&
      FACTORS="[$Pj, $Pi]" || FACTORS+="[$Pi, $Pj]"; break 2
    elif (( PROD > PALINDROME )); then PALINDROME="$PROD" FACTORS="[$Pi, $Pj]"
    elif (( PROD == PALINDROME )); then FACTORS+="[$Pi, $Pj]"; fi
  done
  (( PALINDROME && ( ( INC > 0 && Pi * Pi > PALINDROME ) ||
    ( INC < 0 && Pi * $3 < PALINDROME ) ) )) && break
done; (( PALINDROME > 0 )) && echo "$PALINDROME:$FACTORS" || echo