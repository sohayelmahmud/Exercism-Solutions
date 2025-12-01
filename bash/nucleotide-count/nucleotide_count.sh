#!/usr/bin/env bash

INPUT=$1
ERROR="Invalid nucleotide in strand"

A_COUNT="0"
C_COUNT="0"
G_COUNT="0"
T_COUNT="0"


for NT in $(seq 1 ${#INPUT})
do
	if [ ${INPUT:NT-1:1} == "A" ]
    	then A_COUNT=$(($A_COUNT + 1))
	elif [ ${INPUT:NT-1:1} == "C" ]
    	then C_COUNT=$(($C_COUNT + 1))
	elif [ ${INPUT:NT-1:1} == "G" ]
    	then G_COUNT=$(($G_COUNT + 1))
	elif [ ${INPUT:NT-1:1} == "T" ]
    	then T_COUNT=$(($T_COUNT + 1))
    else
    	echo $ERROR
        exit 1
    fi
done

echo "A: $A_COUNT"
echo "C: $C_COUNT"
echo "G: $G_COUNT"
echo "T: $T_COUNT"