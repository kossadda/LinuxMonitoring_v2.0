#!/bin/bash


mkdir -p logs

for day in {1..5}
do
    log_file="logs/access_$day.log"
    
    echo "Create log for $day day..."
    echo > $log_file
    num_entries=$((RANDOM % 901 + 100))
    
    for ((i=0; i<$num_entries; i++))
    do
        ip_address=$(($RANDOM % 256)).$(($RANDOM % 256)).$(($RANDOM % 256)).$(($RANDOM % 256))

        status_code=$((RANDOM % 10))
        case $status_code in
            0) status_code=200 ;;   # OK
            1) status_code=201 ;;   # Created
            2) status_code=400 ;;   # Bad Request
            3) status_code=401 ;;   # Unauthorized
            4) status_code=403 ;;   # Forbidden
            5) status_code=404 ;;   # Not Found
            6) status_code=500 ;;   # Internal Server Error
            7) status_code=501 ;;   # Not Implemented
            8) status_code=502 ;;   # Bad Gateway
            9) status_code=503 ;;   # Service Unavailable
        esac

        methods=("GET" "POST" "PUT" "PATCH" "DELETE")
        method=${methods[$((RANDOM % 5))]}

        date=$(date -d "2023-01-01 +$day days $((RANDOM % 24)) hours $((RANDOM % 60)) minutes $((RANDOM % 60)) seconds" "+%d/%b/%Y:%H:%M:%S +0000")

        url="/path/$((RANDOM % 10))"

        agents=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler and bot" "Library and net tool")
        agent=${agents[$((RANDOM % 8))]}

        log_entry="$ip_address - - [$date] \"$method $url\" $status_code 0 \"-\" \"$agent\""
        echo $log_entry >> $log_file
    done
    sed -i '/^$/d' logs/access_$day.log
done

echo "Log files were successfully created"