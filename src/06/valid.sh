#!/bin/bash

validation() {
    code=0

    if [ $# -ne 1 ]; then
        echo "Enter 1 parameter [1-4]"
        code=1
    elif [[ ! "$1" =~ ^[1-4]{1}$ ]]; then
        echo "\"1\" - all records sorted by response code"
        echo "\"2\" - all unique IPs found in records"
        echo "\"3\" - all requests with errors (response code - 4xx or 5xx)"
        echo "\"4\" - all unique IPs that are found among erroneous requests"
        code=1
    else
        for ((i=1; i <=5; i++)); do
            if [ ! -e "$log_dir/access_$i.log" ]; then
                code=1
            fi
        done
        if [ $code -eq 1 ]; then
            echo "The required log files are missing in the ../04/logs/directory"
        fi
    fi

    return $code
}