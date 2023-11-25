#!/bin/bash

create_folders() {
    local nested_folders=$1
    local file_size=$2
    local files_per_folder=$3
    local folder_chars=$4
    local file_chars=$5
    local full_itteraion=$6

    if [ "$nested_folders" -le 0 ]; then
        return
    elif [ "$free_space" -lt 1000000 ]; then
        echo "Not enough free space on the filesystem. Exiting..."
        exit 1
    fi

    for i in $(seq 1 "$full_itteraion"); do
        folder_name=$(use_foldername "$folder_chars")
        while [ -d "$folder_name" ]; do
            folder_name=$(use_foldername "$folder_chars")
        done
        mkdir "$folder_name"
        cd "$folder_name"

        for ((j=1; j<=files_per_folder; j++)); do
            file_name=$(use_filename "$file_chars")
            while [ -e $file_name ]; do
                file_name=$(use_filename "$file_chars")
            done
            dd if=/dev/zero of="$file_name" bs=1024 count="$file_size"
        done

        create_folders "$((nested_folders - 1))" "$file_size" "$files_per_folder" "$folder_chars" "$file_chars" "$full_itteraion"

        cd ..
    done
}