#!/bin/bash

log_dir="../04/logs"
response_codes="200 201 400 401 403 404 500 501 502 503"
error_codes="400 401 403 404 500 501 502 503"

source ./valid.sh

validation $@

if [ $? -eq 0 ]; then
    mkdir -p logs
    for ((i=1; i <= 5; i++)); do
        echo > logs/sort_access_$i.log
        case "$1" in
            1)
                for code in $response_codes; do
                    awk -v code="$code" '$8 == code' "$log_dir/access_$i.log" >> logs/sort_access_$i.log
                done
                ;;
            2)
                sort -k1,1 $log_dir/access_$i.log | uniq -w 15 >> logs/sort_access_$i.log
                ;;
            3)
                for code in $error_codes; do
                    awk -v code="$code" '$8 == code' "$log_dir/access_$i.log" >> logs/sort_access_$i.log
                done
                ;;
            4)
                for code in $error_codes; do
                    awk -v code="$code" '$8 == code' ../04/logs/access_$i.log | sort -k1,1 | uniq -w 15 >> logs/sort_access_$i.log
                done
                ;;
        esac
        sed -i '/^$/d' logs/sort_access_$i.log
    done
    case "$1" in
        1) echo "Log files were successfully sorted by response code";;
        2) echo "Log files were successfully sorted by all unique IPs found in records";;
        3) echo "Log files were successfully sorted by all requests with errors (response code - 4xx or 5xx)";;
        4) echo "Log files were successfully sorted by all unique IPs that are found among erroneous requests";;
    esac
fi

