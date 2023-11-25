#!/bin/bash

file_size=$1
nesting=0

create_folders() {
    if [ $nesting -gt 25 ]; then
        return
    fi
    local files_per_folder=$((RANDOM % 100))

    random_number=$((RANDOM % 15))
    if [ "$random_number" -eq 0 ]; then
        nested_folder=-1 # Установка значения по умолчанию для nested_folder, когда random_number не равен 0
    else
        nested_folder=$((RANDOM % 100))
    fi

    for i in $(seq "$nested_folder"); do
        folder_name="$i"
        mkdir "$folder_name"
        cd "$folder_name"
        nesting=$((nesting + 1))

        create_folders "$file_size"

        cd ..
    done
}


create_folders() {
    local nested_folders=$((RANDOM % (100 - 1) + 1))
    local file_size=$2
    local files_per_folder=$((RANDOM % (100 - 1) + 1))
    local folder_chars=$4
    local file_chars=$5
    local full_itteraion=$6
    free_space=$(df / | tail -n +2 | awk '{printf("%d", $4)}')

    if [ $nested_folders -le 0 ]; then
        return
    elif [ $free_space -le 1000000 ]; then
        echo "Not enough free space on the filesystem. Exiting..."
        exit 1
    fi

    for i in $(seq 1 $((RANDOM % (10 - 1) + 1))); do
        folder_name=$(use_foldername "$folder_chars")
        while [ -d "$folder_name" ]; do
            folder_name=$(use_foldername "$folder_chars")
        done
        mkdir "$folder_name"
        echo "Date $date_for_report created folder: $(pwd)$folder_name" >> $log_file
        cd "$folder_name"

        for ((j=1; j<=$((RANDOM % (100 - 1) + 1)); j++)); do
            file_name=$(use_filename "$file_chars")
            while [ -e $file_name ]; do
                file_name=$(use_filename "$file_chars")
            done
            dd if=/dev/zero of="$file_name" bs=1048576 count="$file_size"
            echo "Date $date_for_report created ${file_size}kb sized file: $(pwd)$file_name" >> $log_file
        done

        create_folders "$((nested_folders - 1))" "$file_size" "$files_per_folder" "$folder_chars" "$file_chars" "$full_itteraion"

        cd ..
    done
}
