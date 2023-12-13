#!/bin/bash

log_dir="../04/logs"

source ./valid.sh

flag_1() {
    flags="--sort-panel=STATUS_CODES,BY_DATA,ASC"
}

flag_2() {
    flags="--sort-panel=HOSTS,BY_DATA,ASC"
}

flag_3() {
    flags="--ignore-status=200 --ignore-status=201"
}

flag_4() {
    parse_3
    flags="$flags --sort-panel=HOSTS,BY_DATA,ASC"
}

validation $@

if [ $? -eq 0 ]; then
    flag_$1 

    read -p "What day's report would you like to generate?: [1-5] " day
    if [[ "$day" =~ [1-5]{1} ]]; then
        goaccess -p goaccess.conf -f ../04/logs/access_$day.log $flags -o report_${day}_day.html
        case "$1" in
            1) echo "Report for $day day created and sorted by response code";;
            2) echo "Report for $day day created and sorted by all unique IPs found in records";;
            3) echo "Report for $day day created and sorted by all requests with errors (response code - 4xx or 5xx)";;
            4) echo "Report for $day day created and sorted by all unique IPs that are found among erroneous requests";;
        esac
    else
        echo "No log file for $day day"
    fi
fi