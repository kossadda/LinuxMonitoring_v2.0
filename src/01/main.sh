#!/bin/bash

date=$(date "+%d%m%y")

target_path=$1
nested_folders=$2
folder_chars=$3
files_per_folder=$4
file_chars=$5
file_size=$6

source ./valid.sh
source ./gen_names.sh
source ./creating.sh

validation $@
if [ $? -eq 0 ]; then
    cd "$target_path"
    full_itteraion=$nested_folders
    create_folders "$nested_folders" "$file_size" "$files_per_folder" "$folder_chars" "$file_chars" "$full_itteraion"
fi