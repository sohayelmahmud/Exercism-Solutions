#!/usr/bin/env bash

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "This library of functions should be sourced into another script" >&2
    exit 4
fi
bash_version=$((10 * BASH_VERSINFO[0] + BASH_VERSINFO[1]))
if (( bash_version < 43 )); then
    echo "This library requires at least bash version 4.3" >&2
    return 4
fi

# Due to inherent bash limitations around word splitting and globbing,
# functions that are intended to *return a list* are instead required to
# receive a nameref parameter, the name of an array variable that will be
# populated in the list function.
# See the filter, map and reverse functions.

# Also note that nameref parameters cannot have the same name as the
# name of the variable in the calling scope.


# Append some elements to the given list.
list::append () {
    local -n __array=$1
    shift
    __array+=("$@")
}

# Return only the list elements that pass the given function.
list::filter () {
    local -n __input=$2
    local -n __output=$3
    for x in "${__input[@]}"; do
        ($1 "$x") && __output+=("$x")
    done
}

# Transform the list elements, using the given function,
# into a new list.
list::map () {
    local -n __input=$2
    local -n _output=$3
    for x in "${__input[@]}"; do
        _output+=( "$("${1}" "$x")" )
    done
}

# Left-fold the list using the function and the initial value.
list::foldl () {
    local out="$2"
    local -n __input=$3
    for x in "${__input[@]}"; do
        out="$( ($1 "$out" "$x") )"
    done
    printf '%s\n' "$out"
}

# Right-fold the list using the function and the initial value.
list::foldr () {
    local out="$2"
    local -n __input=$3
    for (( i="${#__input[@]}"-1; i>=0; i-- )); do
        out="$( ($1 "${__input[i]}" "$out") )"
    done
    echo "$out"
}

# Return the list reversed
list::reverse () {
    local -n __input=$1 out=$2
    for (( i="${#__input[@]}"-1; i>=0; i-- )); do
        out+=("${__input[i]}")
    done
}
