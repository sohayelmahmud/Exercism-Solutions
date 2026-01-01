#!/usr/bin/env bash

main () {
    declare -a stanzas=(
        "fly_I don't know why she swallowed the fly. Perhaps she'll die."
        "spider_PRONOUN wriggled and jiggled and tickled inside her."
        "bird_How absurd to swallow a bird!"
        "cat_Imagine that, to swallow a cat!"
        "dog_What a hog, to swallow a dog!"
        "goat_Just opened her throat and swallowed a goat!"
        "cow_I don't know how she swallowed a cow!"
        "horse_She's dead, of course!"
    )

    (( "$#" != 2 )) && { echo "2 arguments expected."; exit 1; }
    [[ ! $1 =~ [1-8] || ! $2 =~ [1-8] ]] && { echo "Arguments must be numbers between 1 and 8."; exit 1; }
    (( $1 > $2 )) && { echo "Start must be less than or equal to End."; exit 1; }

    local begin=$1
    local end=$2

    for ((i=begin-1; i<end; i++)); do
        IFS="_" read -r -a subject <<< "${stanzas[$i]}"
        printf "I know an old lady who swallowed a %s.\n" "${subject[0]}"
        printf "%s\n" "${subject[1]}" | sed "s/PRONOUN/It/"

        ((i==7)) && break

        for ((j=i; j>=1; j--)); do
            IFS="_" read -r -a sub <<< "${stanzas[$j]}"
            IFS="_" read -r -a next_sub <<< "${stanzas[$((j-1))]}"
            printf "She swallowed the %s to catch the " "${sub[0]}"
            if ((j==2)); then
                printf "%s %s\n" "${next_sub[0]}" "${next_sub[1]}" | sed "s/PRONOUN/that/"
            elif ((j==1)); then
                printf "%s.\n%s\n" "${next_sub[0]}" "${next_sub[1]}"
            else
                printf "%s.\n" "${next_sub[0]}"
            fi
        done
        echo ""
    done
}

# call main with all of the positional arguments
main "$@"
