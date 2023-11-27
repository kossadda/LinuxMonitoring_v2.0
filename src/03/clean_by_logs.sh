#!/bin/bash

log_clean() {
    local files=""
    local presence=$(log_in_folder)

    if [ $presence -eq 1 ]; then
        files=$(grep "_[0-9]\{6\}$" report.log | sed 's/Date [0-9.]\+ created folder: //')
    elif [ $presence -eq 2 ]; then
        files=$(grep "_[0-9]\{6\}$" ../02/report.log | sed 's/Date [0-9.]\+ created folder: //')
    fi

    if [ $presence -ne 0 ]; then
        echo "Removing garbage using a log file..."
        for folder in $files; do
            sudo rm -rf "$folder"
            echo "Folder $folder" deleted >> "$log_file" 
        done
    else
        echo "The report.log file is missing in directory 02 or 03"
    fi

    return 0
}