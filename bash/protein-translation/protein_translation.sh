#!/usr/bin/env bash
# Uncomment for debugging
#set -x

declare -A rna_codon_translations=(
    [AUG]='Methionine'
    [UUU]='Phenylalanine'
    [UUC]='Phenylalanine'
    [UUA]='Leucine'
    [UUG]='Leucine'
    [UCU]='Serine'
    [UCC]='Serine'
    [UCA]='Serine'
    [UCG]='Serine'
    [UAU]='Tyrosine'
    [UAC]='Tyrosine'
    [UGU]='Cysteine'
    [UGC]='Cysteine'
    [UGG]='Tryptophan'
)

[[ $1 =~ [^UAGC] ]] && { echo "Invalid codon" ; exit 1 ; }

for ((i=0; i<${#1}; i+=3 )); do
    amino="${rna_codon_translations[${1:$i:3}]}"
    if [[ "${1:$i:3}" =~ UAA|UAG|UGA ]]; then
        break
    elif [[ ! "$amino" ]]; then
        echo "Invalid codon"
        exit 1
    fi
    translation+=( "$amino" )
done

echo "${translation[@]}"