#!/usr/bin/env bash

LANG=en_us_8859_1

given_date=$(date +"%s" -d "${1}")

giga_date=$(( given_date + (10 ** 9) ))

echo $(date +"%Y-%m-%dT%H:%M:%S" -u -d @${giga_date})