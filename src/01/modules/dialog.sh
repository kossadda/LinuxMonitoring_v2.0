#!/bin/bash

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
  readonly END_TIME=$(date +%s)
  readonly EXECUTE_TIME=$((END_TIME - START_TIME))
  readonly REPORT_END_TIME=$(date '+%Y-%m-%d %H:%M')

  if [[ ${OVERFLOW} -eq 1 ]]; then
    red "\nWARNING: Not enough free disk space\n"
  else
    green "\nTrash generate succefully\n"
  fi

  echo "Script started at ${REPORT_START_TIME}"
  echo "Script finised at ${REPORT_END_TIME}"
  bold "\nGenerated ${YELLOW}${FOLDERS}${RESET} ${BOLD}folders and ${YELLOW}${FILES}${RESET} ${BOLD}files for ${YELLOW}${EXECUTE_TIME}${RESET} ${BOLD}seconds\n"

  report_results

  echo -e "${YELLOW}"
  echo " __________________________________________________________________"
  echo "|                                                                  |"
  echo "|                             COMPLETE                             |"
  echo "|__________________________________________________________________|"
  echo -e "${RESET}"
}

report_results() {
  if [ -e "${SCRIPT_DIR}/report.log" ]; then
    echo -e "${BOLD}File ${YELLOW}${LOG_PATH}${RESET} ${BOLD}contains information about the generation${RESET}"
    sed -i "1s|^|$(echo -e "Script finised at ${REPORT_END_TIME}")\n\n\n|" ${LOG_PATH}
    sed -i "1s|^|$(echo -e "Script started at ${REPORT_START_TIME}")\n|" ${LOG_PATH}
    sed -i "1s|^|$(echo -e "Generated ${FOLDERS} folders and ${FILES} files for ${EXECUTE_TIME} seconds")\n|" ${LOG_PATH}
  fi
}

generate_status() {
  echo -ne "\rIn progress... Generated ${YELLOW}${FOLDERS}${RESET} folders and ${YELLOW}${FILES}${RESET} files"
}

report_file_create() {
  echo "Date ${REPORT_DATE} created ${INPUT_SIZE} sized file: ${folder_in_depth_dir}/${file_name}" >> ${LOG_PATH}
}

report_folder_create() {
  echo "Date ${REPORT_DATE} created folder: ${folder_in_depth_dir}/${folder_name}" >> ${LOG_PATH}
}
