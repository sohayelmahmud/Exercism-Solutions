#!/usr/bin/env bash

usage() {
	printf "Usage: %s (encode|decode) (plaintext|ciphertext)\n" "$0"
	exit 0
}

panic() {
	(($# == 1)) && printf "Err: %s\n" "$1"
	exit 1
}

# Source: https://unix.stackexchange.com/questions/92447/bash-script-to-get-ascii-values-for-alphabet
chr() {
	(($# != 1)) && panic "Invalid Arg Count. Saw $#. Expected 1"
	(($1 > 256)) && panic "$1 is not an ASCII char code"

	printf "\\$(printf '%03o' "$1")"
}

ord() {
	(($# != 1)) && panic "Invalid Arg Count. Saw $#. Expected 1"

	LC_CTYPE=C printf '%d' "'$1"
}

declare char_code_a
char_code_a=$(ord "a")
declare -r char_code_a
declare char_code_z
char_code_z=$(ord "z")

# Symmetric encryption, so used for encode and decode
atbash() {
	(($# != 2)) && panic "Invalid Arg Count. Saw $#. Expected 2"

	# Cast to lowercase and strip all non alphanumerics
	local text="${1,,}"
	text="${text//[![:alnum:]]/}"

	local -n __result=$2
	local char=""
	local -i char_code=0
	local -i result_char_code=0
	for ((i = 0; i < ${#text}; i++)); do
		char="${text:i:1}"
		# Encode all letters, just append numbers
		if [[ $char =~ [[:alpha:]] ]]; then
			char_code=$(ord "$char")
			offset=$((char_code_z - char_code))
			result_char_code=$((char_code_a + offset))
			__result+="$(chr $result_char_code)"
		else
			__result+="$char"
		fi
	done

	return 0
}

encode() {
	(($# != 1)) && panic "Invalid Arg Count. Saw $#. Expected 1"

	local plaintext="$1"
	local buffer=""

	atbash "$plaintext" buffer

	# Break into 5 character "words"
	local -a words=()
	local -i buffer_len=${#buffer}
	for ((i = 0; i < buffer_len; i += 5)); do
		words+=("${buffer:$i:5}")
	done

	# Join into a string delimed by first IFS char
	printf "%s\n" "${words[*]}"
	return 0
}

decode() {
	(($# != 1)) && panic "Invalid Arg Count. Saw $#. Expected 1"

	local ciphertext="$1"
	local plaintext=""

	atbash "$ciphertext" plaintext

	printf "%s\n" "$plaintext"
	return 0
}

main() {
	(($# != 2)) && usage
	local -r command="$1"

	case $command in
		encode)
			encode "$2"
			;;
		decode)
			decode "$2"
			;;
		*)
			usage
			;;
	esac

	return 0
}

main "$@"
