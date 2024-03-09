#!/bin/bash

generate_files_and_folders() {
  overflow=0
  folders=0
  files=0

  overflow_memory
  if [[ ${overflow} -eq 0 ]]; then  
    source ${SCRIPT_DIR}/generate_name.sh

    local depth=1
    create_one_depth ${TRASH_PATH}

    while [ ${folders} -lt ${NEST} ] && [[ ${overflow} -eq 0 ]]; do
      create_depth ${depth}
      ((depth++))
    done
  fi
}

create_depth() {
  local -r depth=$1

  for folder in $(find ${TRASH_PATH} -mindepth ${depth} -maxdepth ${depth} -type d); do
    create_one_depth ${folder}

    if [[ ${folders} -ge ${NEST} ]] || [[ ${overflow} -eq 1 ]]; then
      break
    fi
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
    echo "Date ${DATE} created folder: ${folder_in_depth_dir}/${folder_name}" >> ${LOG_PATH}

    create_files_in_folder "${folder_in_depth_dir}/${folder_name}"
    ((folders++))
    echo -ne "\rIn progress... Generated ${YELLOW}${folders}${RESET} folders and ${YELLOW}${files}${RESET} files" 
    if [[ ${folders} -ge ${NEST} ]] || [[ ${overflow} -eq 1 ]]; then
      break
    fi
  done
}

create_files_in_folder() {
  local folder_in_depth_dir=$1

  for ((j = 0; j < FILES_COUNT; j++)); do
    file_name=$(get_filename)
    while [ -e $file_name ]; do
      file_name=$(get_filename)
    done

    overflow_memory
    if [ ${overflow} -eq 1 ]; then
      break
    fi
    
    fallocate -l ${FILE_SIZE^} ${folder_in_depth_dir}/${file_name} 2>/dev/null
    echo "Date ${DATE} created ${FILE_SIZE}Mb sized file: ${folder_in_depth_dir}/${file_name}" >> ${LOG_PATH}
    echo -ne "\rIn progress... Generated ${YELLOW}${folders}${RESET} folders and ${YELLOW}${files}${RESET} files" 
    ((files++))
  done
}

overflow_memory() {
  local -r memory=$(df / | grep /$ | awk '{print $4}')

  if [[ ${memory} -le 1048576 ]]; then
    overflow=1
  else
    overflow=0
  fi
}
