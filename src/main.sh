#!/bin/bash

date=$(date "+%d%m%y")

target_path=$1
nested_folders=$2
folder_chars=$3
files_per_folder=$4
file_chars=$5
file_size=$6

source ./valid.sh
source ./folders.sh

# validation $@
# if [ $? -eq 0 ]; then
#     echo "$(use_filename)"
#     echo "$(use_foldername)"
# fi

create_folders_and_files() {

    # mkdir -p "$target_path"
    cd "$target_path"

    for ((i = 1; i <= nested_folders; i++)); do
        current_folder=$(use_foldername "$folder_chars")
        mkdir -p "$current_folder"
        cd "$current_folder" || exit 1

        for ((j = 1; j <= files_per_folder; j++)); do
            current_file=$(use_filename "$file_chars")
            echo "Creating file: $current_file"
            dd if=/dev/zero of="$current_file" bs=1024 count="$file_size" 2>/dev/null
        done

        cd ..
    done

}

create_folders_and_files






















# if [ "$free_space" -lt 1000000 ]; then
#     echo "Not enough free space on the filesystem. Exiting..."
#     exit 1
# fi