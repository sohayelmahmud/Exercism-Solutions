#!/usr/bin/env bash

# padToLength <string> <len>
# Add trailing spaces to string to ensure that is length is at least len.
padToLength () {
	printf "% -$2s" "$1"
}

main () {
	# Read input from stdin into array
	local -a input
	readarray -t input

	# Ensure that each row contains at least as many characters as the
	# rows below it (when transposing, this corresponds to padding on
	# the left but not on the right)
	local prevLen="${#input[-1]}"
	for ((i="${#input[@]}"-2; i>=0; i--)); do
		input[i]="$(padToLength "${input[i]}" "$prevLen")"
		prevLen="${#input[i]}"
	done

	# prevLen is now the length of the first row, which is also the
	# longest. Loop over all character indices, printing the
	# corresponding character from each row.
	for ((i=0; i<prevLen; i++)); do
		for row in "${input[@]}"; do
			printf "%s" "${row:i:1}"
		done
		printf "\n"
	done
}

main "$@"
