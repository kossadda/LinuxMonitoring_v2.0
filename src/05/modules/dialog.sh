#!/bin/bash

input_information() {
  echo -en "${YELLOW}"
  echo " __________________________________________________________________"
  echo "|                                                                  |"
  echo "|                        ENTERED PARAMETERS                        |"
  echo "|__________________________________________________________________|"
  echo -e "${RESET}"
  
  case ${1} in
  1) echo -e "${YELLOW}Option:${RESET} sort by response code" ;;
  2) echo -e "${YELLOW}Option:${RESET} filter unique IPs found in records" ;;
  3) echo -e "${YELLOW}Option:${RESET} filter requests with errors (response code - 4xx or 5xx)" ;;
  4) echo -e "${YELLOW}Option:${RESET} filter unique IPs that are found among erroneous requests" ;;
  esac
  
  echo -en "${YELLOW}"
  echo " __________________________________________________________________"
  echo "|                                                                  |"
  echo "|                           START SORTING                          |"
  echo "|__________________________________________________________________|"
  echo -e "${RESET}"
}

output_result() {
  readonly END_TIME=$(date +%s)
  readonly EXECUTE_TIME=$((END_TIME - START_TIME))
  readonly REPORT_END_TIME=$(date '+%Y-%m-%d %H:%M')

  echo -e "\n\nScript started at ${REPORT_START_TIME}"
  echo "Script finised at ${REPORT_END_TIME}"
  bold "\n${BOLD}Sorted ${YELLOW}5${RESET} ${BOLD}log files for ${YELLOW}${EXECUTE_TIME}${RESET} ${BOLD}seconds\n"

  echo -e "${BOLD}All logs you can find in ${YELLOW}${SCRIPT_DIR}/sort_logs${RESET}"

  echo -e "${YELLOW}"
  echo " __________________________________________________________________"
  echo "|                                                                  |"
  echo "|                             COMPLETE                             |"
  echo "|__________________________________________________________________|"
  echo -e "${RESET}"
}

generate_status() {
  echo -ne "\rIn progress... Sorted ${YELLOW}${1}${RESET} logs"
}
