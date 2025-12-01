#!/usr/bin/env bash


name=$1
num=$2

if [[ "$num" =~ 11$|12$|13$ ]]; then
	end="th"

elif [[ "$num" =~ 1$ ]]; then
	end="st"

elif [[ "$num" =~ 2$ ]]; then
	end="nd"

elif [[ "$num" =~ 3$ ]]; then
	end="rd"
else
	end="th"
fi

echo "$name, you are the $num$end customer we serve today. Thank you!"