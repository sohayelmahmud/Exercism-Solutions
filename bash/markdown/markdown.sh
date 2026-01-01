#!/usr/bin/env bash

open_list () {
    if [[ $list_started == "false" ]]; then
        list_started=true
        output+="<ul>"
    fi
}

close_list () {
    if [[ $list_started == "true" ]]; then
        list_started=false
        output+="</ul>"
    fi
}

bold () {
    while true; do
        orig_line=$line
        if [[ $line =~ ^(.+)__(.*)$ ]]; then
            pre_=${BASH_REMATCH[1]}
            post=${BASH_REMATCH[2]}
            if [[ $pre_ =~ ^(.*)__(.+)$ ]]; then
                pre=${BASH_REMATCH[1]}
                middle=${BASH_REMATCH[2]}
                line="${pre}<strong>${middle}</strong>${post}"
            fi
        fi
        [[ "$orig_line" == "$line" ]] && break
    done
}

italic () {
    while [[ $line =~ ^([^_]*)_([^_]+)_(.*)$ ]]; do
        pre=${BASH_REMATCH[1]}
        middle=${BASH_REMATCH[2]}
        post=${BASH_REMATCH[3]}
        line="${pre}<em>${middle}</em>${post}"
    done
}

header () {
    header_level=${line/[^#]*/}
    header_level=${#header_level}
    line="${line#"${line%%[!#]*}"}"
    line="${line# }"
    output+="<h${header_level}>$line</h${header_level}>"
}

list () {
    line="${line#\*}"
    line="${line# }"
    output+="<li>${line}</li>"
}

paragraph () {
    output+="<p>$line</p>"
}

main () {
    list_started=false
    output=""

    while IFS= read -r line; do
        #line_to_output=""

        ## handle bold
        bold "$line"

        ## handle italic
        italic "$line"

        if [[ $line =~ ^#{1,6}[[:space:]].*$ ]]; then
            ## handle header
            close_list
            header "$line"
        elif [[ $line =~ ^\*[[:space:]].*$ ]]; then
            ## handle list
            open_list
            list "$line"
        else
            ## just paragraph
            close_list
            paragraph "$line"
        fi
    done < "$1"

    ## close opened list
    [[ $list_started == true ]] && output+="</ul>"

    ## print the solution
    echo "$output"
}

main "$@"