# #!/bin/bash

create_folder_files() {
    local folder_chars=$1
    local file_chars=$2
    local file_size=$3
    local root=$(pwd)
    local max_depth=0

    create_one_depth  "$folder_chars" "$file_chars" "$file_size" "$root"

    while [ $max_depth -lt 100 ]; do
        create_depth "$folder_chars" "$file_chars" "$file_size" "$max_depth" "$root"
        max_depth=$((max_depth + 1))
        break_num=$((RANDOM % 15))
        if [ $break_num -eq 0 ]; then
            break
        fi
    done

    return 0
}

create_depth() {
    local folder_chars=$1
    local file_chars=$2
    local file_size=$3
    local max_depth=$4
    local root=$5

    for folder in $(find "$root" -mindepth $max_depth -maxdepth $max_depth -type d | sed 's|^\./||'); do
        create_one_depth "$folder_chars" "$file_chars" "$file_size" "$folder"
    done

    return 0
}

create_files_in_folder() {
    local folder_chars=$1
    local file_chars=$2
    local file_size=$3
    local depth_dir=$4
    local num_files=$((RANDOM % (5 - 1) + 1))

    for ((j=0; j<=num_files; j++)); do
        file_name=$(use_filename "$file_chars")
        while [ -e $file_name ]; do
            file_name=$(use_filename "$file_chars")
        done
        free_space=$(df / | tail -n +2 | awk '{printf("%d", $4 * 1024)}')
        if [ $free_space -le 1000000000 ]; then
            echo "Not enough free space on the filesystem. Exiting..."
            echo "Script execution time (in seconds) = $(echo "$(date +%s.%N) $time_start" | awk '{printf "%.3f", $1 - $2}')" >> $log_file
            exit 1
        else
            sudo fallocate -l ${file_size^} $depth_dir/$file_name 2>/dev/null
        fi
        echo "Date $date_for_report created $(($file_size / 1024 / 1024))Mb sized file: $depth_dir/$file_name" >> $log_file
    done

    return 0
}

create_one_depth() {
    local folder_chars=$1
    local file_chars=$2
    local file_size="$(($3 * 1024 *1024))"
    local depth_dir=$4
    nest_num=$((RANDOM % (7 - 1) + 1))

    for ((i=0; i < $nest_num; i++)); do
        local folder_name=$(use_foldername "$folder_chars")
        while [ -d "$depth_dir/$folder_name" ]; do
            folder_name=$(use_foldername "$folder_chars")
        done
        sudo mkdir "$depth_dir/$folder_name"
        echo "Date $date_for_report created folder: $depth_dir/$folder_name" >> $log_file

        # Вызываем функцию для создания файлов в папке
        create_files_in_folder "$folder_chars" "$file_chars" "$file_size" "$depth_dir/$folder_name"
    done

    return 0
}
