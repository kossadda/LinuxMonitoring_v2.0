#!/bin/bash

main() {
  readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  source ${SCRIPT_DIR}/modules/configuration.conf

  if [[ $# -ne 0 ]]; then
    yellow "\nProgram no need parameters. ${RED}Exiting from program...${RESET}\n" 1>&2
    exit 1
  fi

  source ${SCRIPT_DIR}/modules/dialog.sh
  input_information ${1}

  source ${SCRIPT_DIR}/modules/generate_logs.sh
  
  generate_logs

  output_result
}

main $@
