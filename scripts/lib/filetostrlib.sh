#!/bin/bash

join_file_lines() {
    file="$1"
    prefix=""
    sufix=""
    sep="\n"

    if [ -n "$2" ]; then
        prefix="$2"
    fi

    if [ -n "$3" ]; then
        sufix="$3"
    fi

    if [ -n "$4" ]; then
        sep="$4"
    fi

    result=""

    while read line; do
        if [ -n "$line" ]; then
            result="$prefix$line$sufix$sep$result"
        fi
    done <"$file"

    if [ -n "$result" ]; then
        result_size=${#result}
        sep_size=${#sep}
        result_cursor=$((result_size-sep_size))
        echo "${result:0:result_cursor}"
    fi
}
