#!/bin/bash

create_folders() {
    local nested_folders=$1
    local file_size=$2
    local files_per_folder=$3
    local folder_chars=$4
    local file_chars=$5
    free_space=$(df / | tail -n +2 | awk '{printf("%d", $4)}')

    for i in $(seq 1 "$nested_folders"); do

        if [ $free_space -le 1000000 ]; then
            echo "Not enough free space on the filesystem. Exiting..."
            exit 1
        fi

        folder_name=$(use_foldername "$folder_chars")
        while [ -d "$folder_name" ]; do
            folder_name=$(use_foldername "$folder_chars")
        done
        mkdir "$folder_name"
        echo "Date $date_for_report created folder: $(pwd)/$folder_name" >> $log_file

        for ((j=1; j<=files_per_folder; j++)); do
            file_name=$(use_filename "$file_chars")
            while [ -e "$folder_name/$file_name" ]; do
                file_name=$(use_filename "$file_chars")
            done
            dd if=/dev/zero of="$folder_name/$file_name" bs=1024 count="$file_size"
            echo "Date $date_for_report created ${file_size}kb sized file: $(pwd)/$folder_name/$file_name" >> $log_file
        done

    done
}