#!/bin/bash

method=$1

source ./valid.sh
source ./clean_by_log.sh
source ./clean_by_date.sh

validation $@

if [ $? -eq 0 ]; then
    if [ $method -eq 1 ]; then
        log_clean
    elif [ $method -eq 2 ]; then
        timedate_clean
    fi
fi