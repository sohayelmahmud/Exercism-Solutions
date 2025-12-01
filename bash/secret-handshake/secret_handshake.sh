#!/usr/bin/env bash

events=(wink 'double blink' 'close your eyes' jump)

((reverse = $1 >> 4 & 1))

for i in "${!events[@]}"; do
    if (($1 >> i & 1)); then
        ((reverse)) && result="${events[i]},$result" || result+="${events[i]},"
    fi
done

echo "${result%,}"
