#!/bin/bash

date=$(date "+%d%m%y")

PATH=$1
NEST=$2
CHAR=$3
FNUM=$4
FCHAR=$5
SIZE=$6

source ./valid.sh
source ./folders.sh

validation $@
if [ $? -eq 0 ]; then
    echo "$(use_filename)"
    echo "$(use_foldername)"
fi


























# if [ "$free_space" -lt 1000000 ]; then
#     echo "Not enough free space on the filesystem. Exiting..."
#     exit 1
# fi