#!/bin/bash

date=$(date "+%d%m%y")

name=$((RANDOM % 1000))
create_folders() {
    nest_num=$((RANDOM % (100 - 10) + 10))
    for ((i=0; i < $nest_num; i++)); do
        names="$((RANDOM % 1000))${name}_$date"
        mkdir $names
    done
}

all() {
    create_folders
    all_nest_num=$((RANDOM % (100 - 10) + 10))
    for ((i=0; i < $all_nest_num; i++)); do
        for folder in $(find . -maxdepth 1 -type d -name "*$date*"); do
            cd "$(basename "$folder")"
            ordinary_create "$(pwd)"
            cd ..
        done
    done
}

ordinary_create() {
    root=$1
    folder_num=$((RANDOM % (100 - 10) + 10))
    for((j=0; j < $folder_num; j++)); do
        mini_ordinary=$((RANDOM % 10))
        for((k=0; k < $mini_ordinary; k++)); do
            names="$((RANDOM % 1000))${name}_$date"
            mkdir $names
            # сюда присобачить создание файлов
        done
        rand=$((RANDOM % 10))
        if [ $rand -eq 0 ]; then
            continue
        fi
        names="$((RANDOM % 1000))${name}_$date"
        mkdir $names
        # сюда присобачить создание файлов
        cd $names
    done
    cd $root
}


cd test
all