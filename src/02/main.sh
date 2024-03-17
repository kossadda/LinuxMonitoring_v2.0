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

  readonly FOLDER_CHARS=${1}
  readonly FILE_CHARS=$(echo ${2} | awk -F. '{print $1}')
  readonly FILE_EXTENSION=$(echo ${2} | awk -F. '{print $2}')
  readonly INPUT_SIZE=${3}
  readonly FILE_SIZE=$((${3::-2} * 1048576))

  source ${SCRIPT_DIR}/modules/dialog.sh
  input_information ${2} ${3}

  source ${SCRIPT_DIR}/modules/generate_files.sh
  generate_files_and_folders

  output_result
}

main $@
