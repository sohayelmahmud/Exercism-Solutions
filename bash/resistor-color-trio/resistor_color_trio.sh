#!/usr/bin/env bash

declare -Ar colors=(
    [black]=0
    [brown]=1
    [red]=2
    [orange]=3
    [yellow]=4
    [green]=5
    [blue]=6
    [violet]=7
    [grey]=8
    [white]=9
);

declare -ar prefixes=(
    'kilo'
    'mega'
    'giga'
);

get_prefix () {
    for index in $(seq ${#prefixes} -1 0); do
        local num=$(( 1000 ** ($index + 1) ))
        if [[ $(( $1 % $num )) -eq 0 ]]; then
            echo $(($1 / $num))' '${prefixes[$index]}
            return
        fi
    done;

    echo $1' '
}

stop_invalid_color () {
    if ! [[ ${colors[$1]} ]]; then
        >&2 echo "Invalid color $1";
        exit 1;
    fi
}

main () {
    stop_invalid_color "$1" && stop_invalid_color "$2" && stop_invalid_color "$3"

    local zeros=$(echo $(( 10**"${colors[$3]}" )) | grep -o '0\{1,\}');
    local value="${colors[$1]}${colors[$2]}"$zeros;
    local value=$( sed 's/^0//' <<< $value);
    local prefix=''

    echo $(get_prefix "$value")"ohms";
}

main "$@"
