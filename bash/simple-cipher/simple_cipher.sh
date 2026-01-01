#!/usr/bin/env bash

# shellcheck disable=SC2059

ALPHA=({a..z}) KEY=
for (( i = 0; i < 256; i++ )); do KEY+="${ALPHA[$RANDOM % 26]}"; done

while (( $# > 0 )); do case "$1" in
  -k) shift; KEY="$1" ;;
  encode|decode|key) DO="$1" ;;
  *) TEXT="${1,,}" ;;
esac; shift; done

[[ "$KEY" =~ ^[a-z][a-z]*$ ]] || { echo "invalid key" >&2; exit 1; }

function ord { printf "%d" "'$1"; }
function code { local i k ORD_OUT ORD_IN ORD_KEY IN="$1" VECTOR="$2"
  for (( i = 0; i < ${#IN}; i++ )); do (( k = i % ${#KEY} ))
    ORD_IN="$(ord "${IN:$i:1}")" ORD_KEY="$(ord "${KEY:$k:1}")"
    (( ORD_OUT = ORD_IN - 97 + ( ORD_KEY - 97 ) * VECTOR + 26 ))
    printf "\x$(printf "%x" "$(( 97 + ORD_OUT % 26 ))")"
  done
}

if [[ "$DO" = "key" ]]; then echo "$KEY"
elif [[ "$DO" = "encode" ]]; then code "$TEXT" 1
elif [[ "$DO" = "decode" ]]; then code "$TEXT" -1; fi
