#!/usr/bin/env bash

stack=()

top=0

declare -A macros

push_stack() {
    stack[top]="$1"
    ((top++))
}

check_stack() {
    len="${#stack[@]}"
    if [[ $len -lt $1 ]]; then
        if [[ $len -eq 1 ]]; then
            echo "only one value on the stack"
            exit 1
        fi
        if [[ $len -eq 0 ]]; then
            echo "empty stack"
            exit 1
        fi
    fi
}

list_stack() {
    echo "${stack[@]:0:$top}"
}

binary_ops() {
    check_stack 2
    ((top--))
    rhs=${stack[top]}
    if [[ $1 == "/" && rhs -eq 0 ]]; then
        echo "divide by zero"
        exit 1
    fi
    ((top--))
    lhs=${stack[top]}
    push_stack "$(( $lhs $1 $rhs ))"
}

dup_item() {
    check_stack 1
    d=${stack[(( top - 1 ))]}
    push_stack $d
}

drop_item() {
    check_stack 1
    ((top--))
}

swap_itmes() {
    check_stack 2
    ((top--))
    item_right=${stack[top]}
    ((top--))
    item_left=${stack[top]}
    push_stack $item_right
    push_stack $item_left
}

over_item() {
    check_stack 2
    item=${stack[(( top - 2 ))]}
    push_stack $item
}

parse_token() {
    grep -P '^-?[\d]+$' <<< "$1" > /dev/null
    if [[ $? -eq 0 ]]; then
        push_stack "$1"
        return 0
    fi
    if [ ${macros[$1]+_} ]; then
        read -a terms <<< ${macros[$1]}
        for t in ${terms[@]}; do
            parse_token $t
        done
        return 0
    fi
    if [[ $1 == "*" ]]; then
        binary_ops "$1"
        return 0
    fi
    case "$1" in
        +|-|/ )
            binary_ops $1
            return 0
            ;;
        dup)
            dup_item
            return 0
            ;;
        drop)
            drop_item
            return 0
            ;;
        swap)
            swap_itmes
            return 0
            ;;
        over)
            over_item
            return 0
            ;;
    esac
    echo "undefined operation"
    exit 1
}

search_macro_value() {
    key="$1"
    while [ ${macros[$key]+_} ]; do
        key=${macros[$key]}
    done
    echo "$key"
}

set_macro() {
    if [[ "${@: -1}" != ';' ]]; then
        echo "macro not terminated with semicolon"
        exit 1
    fi
    if [[ ${#@} -lt 3 ]]; then
        echo "empty macro definition"
        exit 1
    fi
    grep -P '^-?[\d]+$' <<< $1 > /dev/null
    if [[ $? -eq 0 ]]; then
        echo "illegal operation"
        exit 1
    fi
    value=''
    for w in "${@:2:$(( ${#@} - 2 ))}"; do
        w=$(tr A-Z a-z <<< $w)
        value="${value} $(search_macro_value $w)"
    done
    key=$(tr A-Z a-z <<< $1)
    macros[$key]="$value"
}

set -f

while read line; do
    read -a args <<< "$line"
    if [[ ${args[0]} == ":" ]]; then
        set_macro "${args[1]}" "${args[@]:2:$(( ${#args[@]} - 2 ))}"
        continue
    fi
    for a in "${args[@]}"; do
        a=$(tr A-Z a-z <<< $a)
        parse_token "$a"
    done
done

list_stack