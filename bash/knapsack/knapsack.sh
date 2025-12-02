#!/usr/bin/env bash

(( $# == 0 )) && exit 1
maxw=$1; shift
while [[ $1 ]]; do
    IFS=: read -r a b <<< $1
    wi+=($a); vi+=($b)
    shift
done

max() { (( $1 > $2 )) && echo $1 || echo $2; }

len=${#wi[@]}
maxwx=$((maxw+1))
for (( i=0; i<len+1; i++ )); do
    for (( j=0; j<maxwx; j++ )); do
        if (( i == 0 || j == 0 )); then
            k[$((j+i*maxwx))]=0
        elif (( wi[$((i-1))] <= j )); then
            m1=$(( ${vi[$((i-1))]} + k[$((maxwx*(i-1) + j - wi[i-1]))] ))
            m2=${k[$((maxwx*(i-1)+j))]}
            k[$((j+i*maxwx))]=$(max $m1 $m2)
        else
            k[$((j+i*maxwx))]=${k[$((j+(i-1)*maxwx))]}
        fi
    done
done
echo ${k[$((len*maxwx + maxw))]}
