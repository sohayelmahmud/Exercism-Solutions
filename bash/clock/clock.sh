#!/usr/bin/env bash

if (( "$#"!=2 && "$#"!=4 )); then
	printf "invalid arguments: program takes exactly two or four arguments\n" >&2
	exit 1
fi

declare -i h="$1" m="$2" delta="$4"
if [[ "$h" != "$1" ]] || [[ "$m" != "$2" ]] || [[ "$delta" != "${4:-0}" ]]; then
	printf "invalid arguments: inputs one, two, and four (if present) must be integers\n" >&2
	exit 2
fi

# Add the time delta if present
case "$3" in
	"") ;;
	"+") (( m+=delta ));;
	"-") (( m-=delta ));;
	*)
		printf "invalid arguments: '%s' is not a valid sign\n" "$3" >&2
		exit 3;;
esac

# Convert minutes greater than 59 to hours. Note when applying mod to
# a negative number in Bash, the remainder will be negative as well.
(( h=(h+m/60)%24 ))
(( m%=60 ))

# Handle negative values of minutes and hours. Notice that at this
# point, hours are in [-23, 23], and minutes in [-59,59]
if (( m<0 )); then
	(( m+=60 ))
	(( h-- ))
fi
(( h<0 )) && (( h+=24 ))

# Format the output
printf "%02d:%02d\n" "$h" "$m"
