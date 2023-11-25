#!/bin/bash

log_file="$(pwd)/report.log"
date_for_report=$(date "+%d.%m.%y")
date=$(date "+%d%m%y")

if [ ${#6} -ge 3 ]; then
    trimmed_size="${6::-2}"
else
    trimmed_size="$6"
fi

target_path=$1
nested_folders=$2
folder_chars=$3
files_per_folder=$4
file_chars=$5
file_size=$trimmed_size

source ./valid.sh
source ./gen_names.sh
source ./creating.sh

validation $@
if [ $? -eq 0 ]; then
    cd "$target_path"
    full_itteraion=$nested_folders
    create_folders "$nested_folders" "$file_size" "$files_per_folder" "$folder_chars" "$file_chars" "$full_itteraion"
fi