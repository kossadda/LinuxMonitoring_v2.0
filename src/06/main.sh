#!/bin/bash

main() {
  readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  source ${SCRIPT_DIR}/modules/configuration.conf
  
  source ${SCRIPT_DIR}/modules/validation.sh
  validation $@
  if [[ $? -eq 1 ]]; then
    yellow "\nPlease try again. ${RED}Exiting from program...${RESET}\n"
    exit 1
  fi

  source ${SCRIPT_DIR}/modules/dialog.sh
  input_information ${1}

  source ${SCRIPT_DIR}/modules/options.sh
  sort_and_filters ${1}

  output_result
}

main $@
