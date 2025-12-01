#!/usr/bin/env bash

main()
{
	local -i n=$1
	local -A arr
	local -i s=0
	shift
	for d in "$@"; do
		(( d > 0 )) || continue
		for (( i=d; i<n; i+=d )); do
			[[ -z ${arr[$i]} ]] && arr[$i]=1 && (( s+=i ))
		done
	done
	echo $s
}

main "$@"
