#!/bin/bash

log_file="clean_report.log"

timedate_clean() {

    echo "Enter the date and time the garbage was created in the format YYYY-MM-DD HH-MM."
    echo "Example input: $(date '+%Y-%m-%d %H:%M')"
    
    read -p "Enter the start time for garbage generation: " start
    time_check "$start"
    read -p "Enter the end time for garbage creation: " end
    time_check "$end"

    sudo find / -newermt "$start" -not -newermt "$end" 2>/dev/null | while read -r file; do
        if [[ $file =~ _[0-9]{6}$ ]]; then
            echo "Deleted folder: $file" >> "$log_file" 
            sudo rm -r "$file" 2>/dev/null
        fi
    done

    echo "Removal completed" >> "$log_file"
}