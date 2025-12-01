#!/usr/bin/env bash

# Function to perform the rotational cipher
rotate() {
    local text="$1"
    local shift_key="$2"
    local result=""

    # Iterate through each character of the input text
    for (( i=0; i<${#text}; i++ )); do
        char="${text:$i:1}"
        ascii_val=$(printf "%d" "'${char}")

        # Check if the character is an uppercase letter
        if (( ascii_val >= 65 && ascii_val <= 90 )); then
            # Calculate the new ASCII value for uppercase letters
            new_ascii_val=$(( ((ascii_val - 65 + shift_key) % 26) + 65 ))
            result+=$(printf "\\$(printf '%o' "$new_ascii_val")")
        # Check if the character is a lowercase letter
        elif (( ascii_val >= 97 && ascii_val <= 122 )); then
            # Calculate the new ASCII value for lowercase letters
            new_ascii_val=$(( ((ascii_val - 97 + shift_key) % 26) + 97 ))
            result+=$(printf "\\$(printf '%o' "$new_ascii_val")")
        else
            # If not a letter, append the character as is
            result+="$char"
        fi
    done
    echo "$result"
}

# Read input from command line arguments
main() {
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: rotational_cipher.sh <text> <shift_key>"
        exit 1
    fi
    local input_text="$1"
    local key="$2"
    rotate "$input_text" "$key"
}

# Call the main function with command line arguments
main "$@"