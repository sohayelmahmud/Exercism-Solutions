#!/usr/bin/env bash

A="${1//[^0-9 ]}" B="${2//[^0-9 ]}"
if [[ "$A" = "$B" ]]; then echo "equal"
elif [[ -z "$A" || " $B " == *" $A "* ]]; then echo "sublist"
elif [[ -z "$B" || " $A " == *" $B "* ]]; then echo "superlist"
else echo "unequal"; fi
