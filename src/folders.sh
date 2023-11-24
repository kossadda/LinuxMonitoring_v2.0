#!/bin/bash

date=$(date "+%d%m%y")

CHAR=$1

symbols() {
    for ((i = 0; i < ${#chars}; i++)); do
        char="${chars:$i:1}"
        if [[ ! "$sym" == *"$char"* ]]; then
            local sym="${sym}${char}"
        fi
    done
    echo "$sym"
}

add_symbol() {
    local chars=$CHAR
    local sym=$(symbols "$chars")
    local index=$((RANDOM % ${#sym}))
    local insert="${sym:index:1}"
    local inserted=false
    for ((i = 0; i < ${#sym}; i++)); do
        char="${sym:$i:1}"
        local res="${res}${char}"
        if [ "$char" == "$insert" ] && [ "$inserted" == false ]; then
            res="${res}${insert}"
            inserted=true
        fi
    done
    echo "$res"
}

folder_name() {
    # local index=$((RANDOM % ${#sym}))
    local chars=$CHAR
    local name=$(symbols "$chars")
    while [ ${#name} -lt $((RANDOM % (8 - 4) + 4)) ]; do
        name=$(add_symbol "$sym")
        sym=$name
    done
    echo "${name}_$date"
}

echo "$(folder_name)"