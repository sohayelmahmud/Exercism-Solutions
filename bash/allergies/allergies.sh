#!/usr/bin/env bash

score=$1
method=$2
allergies=$3

allergens=('eggs' 'peanuts' 'shellfish' 'strawberries' 'tomatoes' 'chocolate' 'pollen' 'cats')

list=''

function genlist(){
    # get a list of index numbers for allergens
    for i in "${!allergens[@]}"; do
        # if the bit for that position is not zero add the allergen
        num=$(( $score & $(( 1 << $i )) ));
        if [[ $num -gt 0 ]]; then list+=" ${allergens[$i]}"; fi
    done
}

function allergic_to(){
    if [[ "$list" =~ "$allergies" ]]; then echo "true"
    else echo "false"
    fi
}

genlist  # do this regardless...

if [[ $method == 'list' ]]; then echo $list; fi
if [[ $method == 'allergic_to' ]]; then allergic_to; fi
