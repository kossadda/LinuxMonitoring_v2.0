#!/bin/bash

mask_clean() {
    read -p "Enter the file name mask in this format \"filename_$date\": " folder
    check_folder_mask "$folder"
    read -p "Enter the file name mask in this format \"filename_$date.txt\": " file
    check_file_mask "$file"

    foldername="${folder%%_*}"
    folder_date="${folder//[^0-9]/}"
    filename="${file%%_*}"
    file_date="${file//[^0-9]/}"
    format="${file##*.}"

    echo "Removing garbage using a mask..."
    all_files=$(sudo find / -type f -print 2>/dev/null | grep -E "[$filename]+_$file_date.$format")
    all_folders=$(sudo find / -type d -print 2>/dev/null | grep -E "[$foldername]+_$folder_date")

    for one_file in $all_files; do
        sudo rm -rf "$one_file"
        echo "File $one_file" deleted >> "$log_file" 
    done
    for one_folder in $all_folders; do
        sudo rm -rf "$one_folder"
        echo "Folder $one_folder" deleted >> "$log_file" 
    done

    echo "Удаление завершено."
}