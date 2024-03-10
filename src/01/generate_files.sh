#!/bin/bash

generate_files_and_folders() {
  check_overflow_memory
  
  if [[ ${OVERFLOW} -eq 0 ]]; then  
    source ${SCRIPT_DIR}/generate_name.sh

    local depth=1
    create_one_depth ${TRASH_PATH}

    while [ ${FOLDERS} -lt ${NEST} ] && [[ ${OVERFLOW} -eq 0 ]]; do
      create_depth ${depth}
      ((depth++))
    done
  fi
}

create_depth() {
  local -r depth=$1

  for folder in $(find ${TRASH_PATH} -mindepth ${depth} -maxdepth ${depth} -type d); do
    if ! [[ ${folder##*/} =~ ^[a-zA-Z]*_[0-9]{6}$ ]]; then
      continue
    elif [[ ${FOLDERS} -ge ${NEST} ]] || [[ ${OVERFLOW} -eq 1 ]]; then
      break
    fi

    create_one_depth ${folder}
  done
}

create_one_depth() {
  local folder_in_depth_dir=$1
  local nest_num=$((RANDOM % (10 - 5) + 5))
  local folder_name

  for ((i = 0; i < nest_num; i++)); do
    folder_name=$(get_foldername)
    while [ -d "${folder_in_depth_dir}/${folder_name}" ]; do
      folder_name=$(get_foldername)
    done
    mkdir "${folder_in_depth_dir}/${folder_name}"
    report_folder_create
    ((FOLDERS++))
    create_files_in_folder "${folder_in_depth_dir}/${folder_name}"
    if [[ ${FOLDERS} -ge ${NEST} ]] || [[ ${OVERFLOW} -eq 1 ]]; then
      generate_status
      break
    fi
  done
}

create_files_in_folder() {
  local folder_in_depth_dir=$1

  for ((j = 0; j < FILES_COUNT; j++, ++FILES)); do
    file_name=$(get_filename)
    while [ -e "${folder_in_depth_dir}/${file_name}" ]; do
      file_name=$(get_filename)
    done

    check_overflow_memory
    if [ ${OVERFLOW} -eq 1 ]; then
      break
    fi
    
    fallocate -l ${FILE_SIZE^} ${folder_in_depth_dir}/${file_name} 2>/dev/null
    report_file_create
    generate_status
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
