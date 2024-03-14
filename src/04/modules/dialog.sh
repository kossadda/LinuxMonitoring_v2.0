#!/bin/bash

input_information() {
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

  echo -e "\n\nScript started at ${REPORT_START_TIME}"
  echo "Script finised at ${REPORT_END_TIME}"
  bold "\n${RESET}Generated ${YELLOW}5${RESET} ${BOLD}log files for ${YELLOW}${EXECUTE_TIME}${RESET} ${BOLD}seconds\n"

  echo -e "${BOLD}All logs you can find in ${YELLOW}${SCRIPT_DIR}/logs${RESET}"

  echo -e "${YELLOW}"
  echo " __________________________________________________________________"
  echo "|                                                                  |"
  echo "|                             COMPLETE                             |"
  echo "|__________________________________________________________________|"
  echo -e "${RESET}"
}

generate_status() {
  echo -ne "\rIn progress... Generated ${YELLOW}${1}${RESET} logs"
}
