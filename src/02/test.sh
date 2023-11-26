#!/bin/bash

source ./gen_names.sh

date_for_report=$(date "+%d.%m.%y")
file_size=$1
folder_chars=$2
file_chars=$3
date=$(date "+%d%m%y")
log_file="$(pwd)/report.log"
root_begin=$(pwd)

create_folder_files() {
    local file_size=$1
    local folder_chars=$2
    local file_chars=$3
    local root=$(pwd)
    create_one_depth "$file_size" "$folder_chars" "$file_chars" "$root"
    local max_depth=0
    while [ $max_depth -lt 100 ]; do
        create_create_folder_files_depth "$file_size" "$folder_chars" "$file_chars" "$max_depth" "$root"
        max_depth=$((max_depth + 1))
        break_num=$((RANDOM % 15))
        if [ $break_num -eq 0 ]; then
            break
        fi
    done
}

create_create_folder_files_depth() {
    local file_size=$1
    local folder_chars=$2
    local file_chars=$3
    local max_depth=$4
    local root=$5
    for folder in $(find "$root" -mindepth $max_depth -maxdepth $max_depth -type d | sed 's|^\./||'); do
        create_one_depth "$file_size" "$folder_chars" "$file_chars" "$folder"
    done
}

create_one_depth() {
    local file_size="$(($1 * 1024 *1024))"
    local folder_chars=$2
    local file_chars=$3
    local depth_dir=$4
    nest_num=$((RANDOM % (7 - 1) + 1))
    for ((i=0; i < $nest_num; i++)); do
        local folder_name=$(use_foldername "$folder_chars")
        while [ -d "$depth_dir/$folder_name" ]; do
            folder_name=$(use_foldername "$folder_chars")
        done
        sudo mkdir "$depth_dir/$folder_name"
        echo "Date $date_for_report created folder: $depth_dir/$folder_name" >> $log_file

        local num_files=$((RANDOM % (5 - 1) + 1))
        for ((j=0; j<=num_files; j++)); do
            file_name=$(use_filename "$file_chars")
            while [ -e $file_name ]; do
                file_name=$(use_filename "$file_chars")
            done
            free_space=$(df / | tail -n +2 | awk '{printf("%d", $4 * 1024)}')

            if [ $free_space -le 1000000000 ]; then
                echo "Not enough free space on the filesystem. Exiting..."

                # Delete 
                read -p "Do you want clean trash? (Y(y)/N(n) " decision
                case $decision in
                    y|Y)
                        cd $random_directory
                        sudo rm -rf school21_task
                        ;;
                    *)
                        echo "End of script without cleaning"
                        break
                        ;;
                esac
                # Delete

                exit 1
            else
                sudo fallocate -l ${file_size^} $depth_dir/$file_name 2>/dev/null
            fi

            echo "Date $date_for_report created $(($file_size / 1024 / 1024))Mb sized file: /$depth_dir/$file_name" >> $log_file
        done

    done
}

sudo echo "Search random directory..."
random_directory=$(sudo find / -type d ! -path '*/bin*' ! -path '*/sbin*' | sort -R | head -n 1)
sudo mkdir "$random_directory/school21_task"
cd "$random_directory/school21_task"
echo "Date $date_for_report created ROOT folder: $random_directory/school21_task" >> $log_file
create_folder_files "$file_size" "$folder_chars" "$file_chars"