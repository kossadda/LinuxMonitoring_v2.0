#!/bin/bash

target_path=$1
nested_folders=$2
folder_chars=$3
files_per_folder=$4
file_chars=$5
file_size=$6
full_itteraion=$2
date=$(date "+%d%m%y")

source ./folders.sh

create_folders() {
    local nested_folders=$1
    local file_size=$2
    local files_per_folder=$3
    local folder_chars=$4
    local file_chars=$5
    local full=$full_itteraion

    if [ "$nested_folders" -le 0 ]; then
        return
    fi

    for i in {1..full}; do
        folder_name=$(use_foldername "$folder_chars")
        while [ -d "$folder_name" ]; do
            folder_name=$(use_foldername "$folder_chars")
        done
        mkdir "$folder_name"
        cd "$folder_name"

        # Создаем заданное количество файлов заданного размера с префиксом file и расширением txt
        for ((j=1; j<=files_per_folder; j++)); do
            file_name=$(use_filename "$file_chars")
            while [ -e $file_name ]; do
                file_name=$(use_filename "$file_chars")
            done
            dd if=/dev/zero of="$file_name" bs=1 count=0 seek="$file_size"
        done

        create_folders "$((nested_folders - 1))" "$file_size" "$files_per_folder" "$folder_chars" "$file_chars" "$full"

        cd ..
    done
}

cd "$target_path"

create_folders "$nested_folders" "$file_size" "$files_per_folder" "$folder_chars" "$file_chars" "$full_itteration"