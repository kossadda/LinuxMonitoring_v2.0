#!/bin/bash

create_folders() {
    local nested_folders=$1
    local file_size=$2
    local files_per_folder=$3
    local folder_chars=$4
    local file_chars=$5
    local full_itteraion=$6

    if [ $nested_folders -le 0 ]; then
        return
    fi

    for i in $(seq 1 "$full_itteraion"); do
        folder_name=$(use_foldername "$folder_chars")
        while [ -d "$folder_name" ]; do
            folder_name=$(use_foldername "$folder_chars")
        done
        mkdir "$folder_name"
        echo "Date $date_for_report created folder: $(pwd)$folder_name" >> $log_file
        cd "$folder_name"

        for ((j=1; j<=files_per_folder; j++)); do
            file_name=$(use_filename "$file_chars")
            while [ -e $file_name ]; do
                file_name=$(use_filename "$file_chars")
            done
            free_space=$(df / | tail -n +2 | awk '{printf("%d", $4 * 1024)}')
            if [ $free_space -le 1000000000 ]; then
                echo "Not enough free space on the filesystem. Exiting..."
                exit 1
            else
                sudo fallocate -l ${file_size^} $file_name 2>/dev/null
            fi
            echo "Date $date_for_report created ${file_size}kb sized file: $(pwd)$file_name" >> $log_file
        done

        create_folders "$((nested_folders - 1))" "$file_size" "$files_per_folder" "$folder_chars" "$file_chars" "$full_itteraion"

        cd ..
    done

    return 0
}