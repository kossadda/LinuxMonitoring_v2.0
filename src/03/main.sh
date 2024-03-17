#!/bin/bash

main() {
  readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  source ${SCRIPT_DIR}/modules/configuration.conf
  
  source ${SCRIPT_DIR}/modules/validation.sh
  validation $@ 1>&2
  if [[ $? -eq 1 ]]; then
    yellow "\nPlease try again. ${RED}Exiting from program...${RESET}\n" 1>&2
    exit 1
  fi

  source ${SCRIPT_DIR}/modules/dialog.sh
  input_information ${1}

  source ${SCRIPT_DIR}/modules/clean.sh
  clean ${1}

  output_result
}

main $@
