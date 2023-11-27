#!/bin/bash

method=$1
date=$(date '+%d%m%y')
log_file="clean_report.log"

source ./valid.sh
source ./clean_by_logs.sh
source ./clean_by_date.sh
source ./clean_by_mask.sh

validation $@

if [ $? -eq 0 ]; then
    if [ $method -eq 1 ]; then
        log_clean
    elif [ $method -eq 2 ]; then
        timedate_clean
    elif [ $method -eq 3 ]; then
        mask_clean
    fi
fi