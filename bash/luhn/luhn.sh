#!/usr/bin/env bash

set -o errexit
set -o nounset

main() {
  input="${1:-}"
  input="${input//[[:space:]]/}"

  rgx='^([0-9]*[1-9][0-9]*|0{2,})$'
  if ! [[ "$input" =~ $rgx ]]; then
    return 1
  fi

  checksum=0
  for (( i=0; i<${#input}; i++ )); do
    digit="${input:((${#input} - i - 1)):1}"
    if (( digit != 9 )) && (( i % 2 )); then
      digit=$(( (digit * 2) % 9 ))
    fi
    checksum=$(( checksum + digit ))
  done
  [ "$(( checksum % 10 ))" -eq 0 ]
}

main "$@" && echo 'true' || echo 'false'
