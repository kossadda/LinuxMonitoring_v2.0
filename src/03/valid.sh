#!/bin/bash

validation() {
    code=0

    if [ $# -ne 1 ]; then
        echo "Enter 1 parameter"
        echo "\"1\" - deleting by log file"
        echo "\"2\" - deleting by date and time of creation"
        echo "\"3\" - deleting by name mask (i.e. symbols, underscore and date)"
        code=1
    else
        if ! [[ "$method" =~ [1-3]{1} ]]; then
            echo "Parameter 1: garbage cleaning method - integer, length [1-3]  |  example: 1"
            code=1
        fi
    fi

    return $code
}

log_in_folder() {
    local presence=0

    if [ -e "report.log" ]; then
        presence=1
    elif [ -e "../02/report.log" ]; then
        presence=2
    fi

    echo "$presence"
}

check_file_mask() {
    local mask=$1
    if ! [[ "$mask" =~ ^[a-zA-Z]+_[0-9]{6}.[a-zA-Z]{1,3}$ ]]; then
        echo "Error:: Некорректный формат маски"
        exit 1
    fi
}

check_folder_mask() {
    local mask=$1
    if ! [[ "$mask" =~ ^[a-zA-Z]+_[0-9]{6}$ ]]; then
        echo "Error:: Некорректный формат маски"
        exit 1
    fi
}

time_check() {
    local time=$1

    if [[ ! "$time" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}$ ]]; then
        echo "Incorrect date and time format entered"
        exit 1
    fi

    local year="${time:0:4}"
    local month="${time:5:2}"
    local day="${time:8:2}"
    local hour="${time:11:2}"
    local minute="${time:14:2}"
    if [[ "$month" == "0"* ]]; then
        month="${month:1}"
    fi
    if [[ "$day" == "0"* ]]; then
        day="${day:1}"
    fi
    if [[ "$hour" == "0"* ]]; then
        hour="${hour:1}"
    fi
    if [[ "$minute" == "0"* ]]; then
        minute="${minute:1}"
    fi

    if ((year < 0)); then
        echo "Enter the correct year"
        exit 1
    elif (($month < 1 || $month > 12)); then
        echo "Please enter the correct month [1-12]"
        exit 1
    elif (($day < 1 || $day > 31)); then
        echo "Please enter the correct day [1-31]"
        exit 1
    elif (($hour < 0 || $hour > 23)); then
        echo "Please enter the correct hour [00-23]"
        exit 1
    elif (($minute < 0 || $minute > 59)); then
        echo "Please enter the correct minute [00-59]"
        exit 1
    fi

    return 0
}
