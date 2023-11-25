#!/bin/bash

ordinary_symbols() {
    for ((i = 0; i < ${#chars}; i++)); do
        char="${chars:$i:1}"
        if [[ ! "$symbols" == *"$char"* ]]; then
            local symbols="${symbols}${char}"
        fi
    done
    echo "$symbols"
}

add_symbol() {
    local symbols=$(ordinary_symbols "$chars")
    local index=$((RANDOM % ${#symbols}))
    local insert="${symbols:index:1}"
    local inserted=false
    for ((i = 0; i < ${#symbols}; i++)); do
        char="${symbols:$i:1}"
        local res="${res}${char}"
        if [ "$char" == "$insert" ] && [ "$inserted" == false ]; then
            res="${res}${insert}"
            inserted=true
        fi
    done
    echo "$res"
}

name_generation() {
    local name=$(ordinary_symbols "$chars")
    while [ ${#name} -lt $((RANDOM % (8 - 4) + 4)) ]; do
        name=$(add_symbol "$symbols")
        symbols=$name
    done
    echo "${name}_$date"
}


filename_generation() {
    local filename=""
    for ((i = 0; i < ${#chars}; i++)); do
        char="${chars:$i:1}"
        if [ "$char" == "." ]; then
            chars=$filename
            filename="$(name_generation $filename)"
            chars=$file_chars
        fi
        filename="${filename}${char}"
    done
    echo "$filename"
}

use_foldername() {
    chars="$folder_chars"
    folder_name="$(name_generation $chars)"
    echo "$folder_name"
}

use_filename() {
    chars="$file_chars"
    file_name="$(filename_generation $chars)"
    echo "$file_name"
}
