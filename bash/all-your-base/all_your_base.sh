#!/usr/bin/env bash

function die { echo "$1" >&2 ; exit 1; }
function converter {
    [[ "$2" =~ - ]] && die "negative value detected"
    local origin_base="$1" value=($2) return_base="$3" sum=0

    (( origin_base <= 1 || return_base <= 1 )) && die "invalid base"

    digits=$(( ${#value[@]} - 1 ))
    for number in "${value[@]}"; do
        (( number >= origin_base )) && die "digit $number invalid for base $origin_base"
        (( sum += number * (origin_base ** digits--) ))
    done

    while (( sum > 0 )); do
        output+=( $(( sum % return_base )) )
        (( sum /= return_base ))
    done

    #tac to reverse the order of the array
    output=($(printf '%s\n' "${output[@]}" | tac))
    [[ -z "${output[*]}" ]] && output=(0)
    echo "${output[@]}"
}

converter "$1" "$2" "$3"