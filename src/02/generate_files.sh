#!/bin/bash

generate_files_and_folders() {
  check_overflow_memory
  if [[ ${OVERFLOW} -eq 0 ]]; then  
    source ${SCRIPT_DIR}/generate_name.sh

    local trash_array
    if [[ $EUID -eq 0 ]]; then
      trash_array=($(find / -type d 2>/dev/null | grep -Ev '/bin$|/sbin$'))
    else
      trash_array=($(find /home -type d 2>/dev/null))
    fi

    while [[ ${OVERFLOW} -eq 0 ]]; do
      while true; do
        TRASH_PATH=${trash_array[$(( $RANDOM % ${#trash_array[@]} ))]}
        if mkdir ${TRASH_PATH}/test 2>/dev/null; then
          rm -rf ${TRASH_PATH}/test
          break
        fi
      done
      
      local depth=1
      NEST=$((RANDOM % (100 - 10) + 10))
      create_one_depth ${TRASH_PATH}

      while [[ ${SUBFOLDERS} -lt ${NEST} ]] && [[ ${OVERFLOW} -eq 0 ]]; do
        create_depth ${depth}
        ((depth++))
      done

      FOLDERS=$((FOLDERS + SUBFOLDERS))
      SUBFOLDERS=0
    done
  fi
}

create_depth() {
  local -r depth=$1

  for folder in $(find ${TRASH_PATH} -mindepth ${depth} -maxdepth ${depth} -type d); do
    if [[ ${SUBFOLDERS} -ge ${NEST} ]] || [[ ${OVERFLOW} -eq 1 ]]; then
      break
    elif [[ ${folder##*/} =~ ^[a-zA-Z]*_[0-9]{6}$ ]]; then
      create_one_depth ${folder}
    fi
  done
}

create_one_depth() {
  local folder_in_depth_dir=$1
  local nest_num=$((RANDOM % (10 - 5) + 5))
  local folder_name

  for ((i = 0; i < nest_num; i++)); do
    folder_name=$(get_foldername ${folder_in_depth_dir})
    while [[ -d "${folder_in_depth_dir}/${folder_name}" ]]; do
      folder_name=$(get_foldername ${folder_in_depth_dir})
    done

    if mkdir "${folder_in_depth_dir}/${folder_name}"; then
      ((SUBFOLDERS++))
      report_folder_create
      create_files_in_folder "${folder_in_depth_dir}/${folder_name}"
    fi

    if [[ ${SUBFOLDERS} -ge ${NEST} ]] || [[ ${OVERFLOW} -eq 1 ]]; then
      generate_status
      break
    fi
  done
}

create_files_in_folder() {
  local folder_in_depth_dir=$1
  local files_count=$((RANDOM % (25 - 5) + 5))

  for ((j = 0; j < files_count; j++)); do
    file_name=$(get_filename ${folder_in_depth_dir})
    while [[ -e "${folder_in_depth_dir}/${file_name}" ]]; do
      file_name=$(get_filename ${folder_in_depth_dir})
    done

    check_overflow_memory
    if [[ ${OVERFLOW} -eq 1 ]]; then
      break
    fi
    
    if fallocate -l ${FILE_SIZE^} ${folder_in_depth_dir}/${file_name} 2>/dev/null; then
      ((FILES++))
      report_file_create
      generate_status
    fi
  done
}

check_overflow_memory() {
  local -r memory=$(df / | grep /$ | awk '{print $4}')

  if [[ ${memory} -le 1048576 ]]; then
    OVERFLOW=1
  else
    OVERFLOW=0
  fi
}
