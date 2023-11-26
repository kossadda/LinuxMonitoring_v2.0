#!/bin/bash

log_file="$(pwd)/report.log"
date_for_report=$(date "+%d.%m.%y")
date=$(date "+%d%m%y")

if [ ${#3} -ge 3 ]; then
    trimmed_size="${3::-2}"
else
    trimmed_size=101
fi

folder_chars=$1
file_chars=$2
file_size=$trimmed_size

source ./valid.sh
source ./gen_names.sh
source ./creating.sh

validation $@

if [ $? -eq 0 ]; then
    sudo echo "Search random directory..."
    random_directory=$(sudo find / -type d ! -path '*/bin*' ! -path '*/sbin*' | sort -R | head -n 1)
    echo "Date $date_for_report created ROOT folder: $random_directory/school21_task" >> $log_file
    create_folder_files "$folder_chars" "$file_chars" "$file_size"
fi