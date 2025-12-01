#!/usr/bin/env bash

# Transcribe DNA to RNA
transcribe_dna_to_rna() {
    local dna_sequence="$1"
    local rna_sequence=""
    local i

    # Process each nucleotide in the DNA sequence
    for ((i = 0; i < ${#dna_sequence}; i++)); do
        local nucleotide="${dna_sequence:$i:1}"

        # Convert DNA nucleotide to RNA complement
        case "$nucleotide" in
            "G")
                rna_sequence+="C"
                ;;
            "C")
                rna_sequence+="G"
                ;;
            "T")
                rna_sequence+="A"
                ;;
            "A")
                rna_sequence+="U"
                ;;
            *)
                # Invalid nucleotide detected
                echo "Invalid nucleotide detected."
                exit 1
                ;;
        esac
    done

    echo "$rna_sequence"
}

# Validate DNA sequence contains only valid nucleotides
validate_dna_sequence() {
    local sequence="$1"

    # Check if sequence contains only valid DNA nucleotides (A, T, G, C)
    if [[ ! "$sequence" =~ ^[ATGC]*$ ]]; then
        return 1
    fi

    return 0
}

main() {
    local dna_sequence="$1"

    # Handle empty sequence (no arguments)
    if [[ $# -eq 0 ]]; then
        # Output nothing for empty sequence
        exit 0
    fi

    # Handle case with empty string argument
    if [[ -z "$dna_sequence" ]]; then
        # Output nothing for empty string
        exit 0
    fi

    # Validate and transcribe the DNA sequence
    transcribe_dna_to_rna "$dna_sequence"
}

main "$@"