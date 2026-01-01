#!/usr/bin/env bash

result=''
command=$1
a=$2
b=$3
string=${4,,}

if (( a % 2 == 0 || a % 13 == 0 )); then
	echo "a and m must be coprime."
	exit 1
fi

chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}

ord() {
  LC_CTYPE=C printf '%d' "'$1"
}

declare -A encoding
declare -A decoding

A=$(ord 'a')
for (( i = 0; i < 26; ++i )); do
	(( j = (a * i + b) % 26 ))
	dec=$(chr $(( A + i )))
	enc=$(chr $(( A + j )))
	encoding[$dec]=$enc
	decoding[$enc]=$dec
done

case $1 in
  encode)
		for (( i = 0; i < ${#4}; ++i )); do
			letter=${string:$i:1}
			[[ $letter =~ [a-z0-9] ]] || continue
			if (( (${#result} - 5) % 6 == 0 )); then
				result+=' '
			fi
			result+=${encoding[$letter]-$letter}
		done
		;;
  decode)
		for (( i = 0; i < ${#4}; ++i )); do
			letter=${string:$i:1}
			[[ $letter != ' ' ]] || continue
			result+=${decoding[$letter]-$letter}
		done
		;;
esac

echo $result
