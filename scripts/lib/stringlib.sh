#!/bin/bash

escape_sed_regex_chars() {
    input="$1"

    input="${input//"\\"/"\\\\"}"
    input="${input//"&"/"\\&"}"
    input="${input//"["/"\\["}"
    input="${input//"]"/"\\]"}"
    input="${input//"("/"\\("}"
    input="${input//")"/"\\)"}"
    input="${input//"{"/"\\{"}"
    input="${input//"}"/"\\}"}"
    input="${input//"$"/"\\$"}"
    input="${input//"^"/"\\^"}"
    input="${input//"*"/"\\*"}"
    input="${input//"."/"\\."}"

    echo "$input"
}