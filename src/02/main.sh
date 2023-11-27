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
    random_directory=$(find / -type d -readable -executable -not \( -name "*bin*" -o -name "*sbin*" \) -print 2>/dev/null | shuf -n 1)
    cd "$random_directory"
    echo "The trash folder was selected: $random_directory"
    echo "Creating garbage..."
    create_folder_files "$folder_chars" "$file_chars" "$file_size"
    echo "The folder was successfully trashed. The report is saved in the file report.log"
fi
