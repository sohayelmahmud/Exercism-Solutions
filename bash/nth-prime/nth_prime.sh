#!/usr/bin/env bash

[ $1 -le 0 ] && { echo "invalid input"; exit 1 ; }

premiers=($(seq 200000 | factor| awk '/: [0-9]+$/ {print $2}'))

echo ${premiers[$1-1]}
