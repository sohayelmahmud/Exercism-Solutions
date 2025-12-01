#!/usr/bin/env bash

words=${1//-/ }
words=${words//[[:punct:]]/}

for word in $words; do
    acronym+=${word:0:1}
done

echo "${acronym^^}"
