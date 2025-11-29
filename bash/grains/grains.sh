#!/usr/bin/env bash

if [[ $1 == total ]]; then
    printf '%u' -1
else
    if (($1 < 1 || $1 > 64)); then
        echo 'Error: invalid input' 1>&2
        exit 1
    fi

    printf '%u' $((1 << ($1 - 1)))
fi
