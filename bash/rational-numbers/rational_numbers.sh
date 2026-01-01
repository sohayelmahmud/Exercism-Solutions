#!/usr/bin/env bash

IFS=$'/' read -r op1_1 op1_2 <<< "$2"
IFS=$'/' read -r op2_1 op2_2 <<< "$3"

low() {
    local dividend=$1
    local divisor=$2
    local left=1
    while (( left != 0 )); do
        (( left=dividend%divisor ))
        dividend=$divisor
        divisor=$left
    done
    (($2/dividend > 0 )) && echo $(($1/dividend))/$(($2/dividend)) || echo $((-1*$1/dividend))/$((-1*$2/dividend))
}

case $1 in
    "+") op1=$(( op1_1*op2_2 + op2_1*op1_2 ))
        op2=$(( op1_2*op2_2 ))
        low op1 op2 ;;
    "-") op1=$(( op1_1*op2_2 - op2_1*op1_2 )); op2=$(( op1_2*op2_2 )); low op1 op2 ;;
    "*") low $((op1_1*op2_1)) $((op1_2*op2_2)) ;;
    "/") low $((op1_1*op2_2)) $((op1_2*op2_1)) ;;
    abs) l=$(low "$op1_1" "$op1_2");  echo "${l#-}" ;;
    pow) if (( op2_1 < 0 )); then
            low $((op1_2**${op2_1#-})) $((op1_1**${op2_1#-}))
         else
             low $((op1_1**op2_1)) $((op1_2**op2_1))
         fi ;;
    rpow) ret=$( awk 'BEGIN { print ARGV[1]**(ARGV[2]/ARGV[3])}' "$2" "$op2_1" "$op2_2" );
        [[ $ret =~ [.,] ]] && echo "$ret" || echo "${ret}".0 ;;
    reduce) low "$op1_1" "$op1_2" ;;
esac
