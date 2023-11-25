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
    root=$(pwd)
    cd test
    create_folders "$file_size" "$folder_chars" "$file_chars"
fi