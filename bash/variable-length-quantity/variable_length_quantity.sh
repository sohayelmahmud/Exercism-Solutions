#!/usr/bin/env bash

case $1 in
    encode)
        shift
        for inp in "${@}"; do
            inp=$((0X$inp))
            code=( $(printf "%02X" $(( inp & 0x7f )) ) )
            (( inp>>=7 ))
            while (( inp )); do
                code=( $(printf %02X $(( inp & 0x7f | 0x80 ))) ${code[@]} )
                (( inp>>=7 ))
            done
            out+=( ${code[*]} )
        done
        echo "${out[@]}"
        ;;
    decode)
        (( (0x${@: -1} & 0x80) != 0 )) && { echo incomplete byte sequence; exit 1; }
        shift
        for inp in "${@}"; do
            inp=$((0X$inp))
            (( code <<= 7 ))
            (( code += (inp & 0x7f) ))
            (( (inp & 0x80) == 0 )) && { out+=( $(printf "%02X" $code) ); code=0; }
        done
        echo ${out[*]}
        ;;
    *) echo unknown subcommand; exit 1
        ;;
esac
