#!/bin/bash

generate_status() {
  echo -ne "\rIn progress... Generated ${YELLOW}${folders}${RESET} folders and ${YELLOW}${files}${RESET} files"
}

report_file_create() {
  echo "Date ${REPORT_DATE} created ${INPUT_SIZE} sized file: ${folder_in_depth_dir}/${file_name}" >> ${LOG_PATH}
}

report_folder_create() {
  echo "Date ${REPORT_DATE} created folder: ${folder_in_depth_dir}/${folder_name}" >> ${LOG_PATH}
}

input_information() {
  echo -en "${YELLOW}"
  echo " __________________________________________________________________"
  echo "|                                                                  |"
  echo "|                        ENTERED PARAMETERS                        |"
  echo "|__________________________________________________________________|"
  echo -e "${RESET}"

  bold "$(yellow "Path of generate trash:") ${TRASH_PATH}"
  bold "$(yellow "Number of nest folders:") ${NEST}"
  bold "$(yellow "Letters in foldernames:") ${FOLDER_CHARS}"
  bold "$(yellow "Files count per folder:") ${FILES_COUNT}"
  bold "$(yellow "Letters in files names:") ${1}"
  bold "$(yellow "Size of generate trash:") ${2}\n"
  
  echo -en "${YELLOW}"
  echo " __________________________________________________________________"
  echo "|                                                                  |"
  echo "|                         START GENERATING                         |"
  echo "|__________________________________________________________________|"
  echo -e "${RESET}"
}


output_result() {
  local -r end_time=$(date +%s)
  local -r execute_time=$((end_time - start_time))

  if [[ ${overflow} -eq 1 ]]; then
    red "\nWARNING: Not enough free disk space"
  else
    green "\nTrash generate succefully"
  fi

  bold "\nGenerated ${folders} folders and ${files} files for ${execute_time} seconds\n"
  echo -e "${BOLD}File ${YELLOW}${LOG_PATH}${RESET} ${BOLD}contains information about the generation${RESET}"

  echo -e "${YELLOW}"
  echo " __________________________________________________________________"
  echo "|                                                                  |"
  echo "|                             COMPLETE                             |"
  echo "|__________________________________________________________________|"
  echo -e "${RESET}"
}