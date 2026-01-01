#!/usr/bin/env bash

# fast modular exponentiation: (base^exp) % mod
function powmod() {
  local -i base=$1 exp=$2 mod=$3
  local -i res=1
  base=$(( base % mod ))
  while (( exp > 0 )); do
    if (( exp & 1 )); then
      res=$(( (res * base) % mod ))
    fi
    base=$(( (base * base) % mod ))
    exp=$(( exp >> 1 ))
  done
  printf '%d\n' "$res"
}

# random private key in [2, p-1]
function private_key() {
  local -i p=$1
  local -i ns=$((10#$(date +%N) ))   # nanoseconds
  local -i seed=$(( (RANDOM << 16) ^ RANDOM ^ $$ ^ ns ))
  (( seed < 0 )) && seed=$(( -seed ))
  local -i span=$(( p - 2 ))
  if (( span <= 0 )); then
    printf '%d\n' 2
    return
  fi
  local -i a=$(( (seed % span) + 2 ))
  printf '%d\n' "$a"
}

function main() {
  local cmd=$1
  shift

  case "$cmd" in
    privateKey)
      # usage: privateKey p
      private_key "$@"
      ;;
    publicKey)
      # usage: publicKey p g private
      local p=$1 g=$2 private=$3
      powmod "$g" "$private" "$p"
      ;;
    secret)
      # usage: secret p otherPublic private
      local p=$1 otherPublic=$2 private=$3
      powmod "$otherPublic" "$private" "$p"
      ;;
    *)
      echo "Unknown command: $cmd" >&2
      exit 1
      ;;
  esac
}

main "$@"