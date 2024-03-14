#!/bin/bash

input_information() {
  echo -en "${YELLOW}"
  echo " __________________________________________________________________"
  echo "|                                                                  |"
  echo "|                        ENTERED PARAMETERS                        |"
  echo "|__________________________________________________________________|"
  echo -e "${RESET}"
  
  case ${1} in
  1) 
    echo -e "${YELLOW}Cleaning method:${RESET} by log file"
    echo -e "${YELLOW}Path for report:${RESET} ${CLEAN_REPORT_PATH}";;
  2) 
    echo -e "${YELLOW}Cleaning method :${RESET} by time of creating"
    echo -e "${YELLOW}Time of starting:${RESET} ${START_CREATE}"
    echo -e "${YELLOW}Time of ending  :${RESET} ${END_CREATE}";;
  3)
    echo -e "${YELLOW}Cleaning method:${RESET} by name mask"
    echo -e "${YELLOW}Mask for folder:${RESET} ${FOLDER_MASK}";;
  esac
  
  echo -en "${YELLOW}"
  echo " __________________________________________________________________"
  echo "|                                                                  |"
  echo "|                          START CLEANING                          |"
  echo "|__________________________________________________________________|"
  echo -e "${RESET}"
}

output_result() {
  readonly END_TIME=$(date +%s)
  readonly EXECUTE_TIME=$((END_TIME - START_TIME))
  readonly REPORT_END_TIME=$(date '+%Y-%m-%d %H:%M')

  echo -e "\n\nScript started at ${REPORT_START_TIME}"
  echo "Script finised at ${REPORT_END_TIME}"
  bold "\n${BOLD}Deleted ${YELLOW}${FOLDERS}${RESET} ${BOLD}folders for ${YELLOW}${EXECUTE_TIME}${RESET} ${BOLD}seconds\n"

  report_results

  echo -e "${YELLOW}"
  echo " __________________________________________________________________"
  echo "|                                                                  |"
  echo "|                             COMPLETE                             |"
  echo "|__________________________________________________________________|"
  echo -e "${RESET}"
}

report_results() {
  if [ -e "${SCRIPT_DIR}/clean.log" ]; then
    echo -e "${BOLD}File ${YELLOW}${LOG_PATH}${RESET} ${BOLD}contains information about the cleaning${RESET}"
    sed -i "1s|^|$(echo -e "Script finised at ${REPORT_END_TIME}")\n\n\n|" ${LOG_PATH}
    sed -i "1s|^|$(echo -e "Script started at ${REPORT_START_TIME}")\n|" ${LOG_PATH}
    sed -i "1s|^|$(echo -e "Deleted ${FOLDERS} folders for ${EXECUTE_TIME} seconds")\n|" ${LOG_PATH}
  fi
}

generate_status() {
  echo -ne "\rIn progress... Deleted ${YELLOW}${FOLDERS}${RESET} folders"
}

report_folder_clean() {
  echo "${1}" deleted >> ${LOG_PATH}
}

report_not_exist_folder() {
  echo "Can't delete ${1}. Folder does not exist" >> ${LOG_PATH}
}

report_havent_permission_folder() {
  echo "Can't delete ${1}. Haven't permission to delete" >> ${LOG_PATH}
}
