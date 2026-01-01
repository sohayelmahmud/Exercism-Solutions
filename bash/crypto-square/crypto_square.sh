#!/usr/bin/env bash

# Crypto Square cipher implementation
# Usage: ./crypto_square.sh "text"

# Function to normalize text (lowercase, alphanumeric only)
normalize_text() {
    local text="$1"
    # Convert to lowercase and keep only alphanumeric characters
    echo "$text" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]//g'
}

# Function to calculate rectangle dimensions
calculate_dimensions() {
    local length=$1
    local c r

    # Handle empty string case
    if [[ $length -eq 0 ]]; then
        echo "0 0"
        return
    fi

    # Start with square root as base
    c=$(echo "sqrt($length)" | bc -l | cut -d. -f1)

    # Find the smallest c such that:
    # - r * c >= length
    # - c >= r
    # - c - r <= 1
    while true; do
        r=$(( (length + c - 1) / c ))  # Ceiling division: (length + c - 1) / c

        if [[ $((r * c)) -ge $length ]] && [[ $c -ge $r ]] && [[ $((c - r)) -le 1 ]]; then
            break
        fi
        ((c++))
    done

    echo "$r $c"
}

# Function to create the cipher by reading columns
create_cipher() {
    local text="$1"
    local rows="$2"
    local cols="$3"
    local length=${#text}

    # If text is empty, return empty
    if [[ $length -eq 0 ]]; then
        echo ""
        return
    fi

    # Pad text with spaces if needed to fill rectangle
    local padded_length=$((rows * cols))
    while [[ ${#text} -lt $padded_length ]]; do
        text+=" "
    done

    local cipher=""
    local col row pos

    # Read columns from left to right
    for ((col = 0; col < cols; col++)); do
        local column_text=""
        for ((row = 0; row < rows; row++)); do
            pos=$((row * cols + col))
            if [[ $pos -lt ${#text} ]]; then
                column_text+="${text:$pos:1}"
            fi
        done

        # Add column to cipher
        if [[ $col -gt 0 ]]; then
            cipher+=" "
        fi
        cipher+="$column_text"
    done

    echo "$cipher"
}

main() {
    local input="$1"

    # Step 1: Normalize the text
    local normalized
    normalized=$(normalize_text "$input")

    # Handle empty normalized text
    if [[ -z "$normalized" ]]; then
        echo ""
        return
    fi

    # Step 2: Calculate rectangle dimensions
    local length=${#normalized}
    local dimensions
    dimensions=$(calculate_dimensions "$length")
    local rows cols
    read -r rows cols <<< "$dimensions"

    # Step 3: Create cipher by reading columns
    local cipher
    cipher=$(create_cipher "$normalized" "$rows" "$cols")

    echo "$cipher"
}

# Call main with all positional arguments
main "$@"