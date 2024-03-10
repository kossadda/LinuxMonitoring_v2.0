#!/bin/bash

readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly LOG_PATH="${SCRIPT_DIR}/report.log"
readonly DATE=$(date "+%d%m%y")
readonly REPORT_DATE=$(date "+%d.%m.%y")
source ${SCRIPT_DIR}/configuration.conf
source ${SCRIPT_DIR}/dialog.sh

main() {
  local -r start_time=$(date +%s)

  source ${SCRIPT_DIR}/validation.sh
  validation $@
  if [[ $? -eq 1 ]]; then
    red "\nExiting from program\n"
    exit 1
  fi

  readonly TRASH_PATH=${1}
  readonly NEST=${2}
  readonly FOLDER_CHARS=${3}
  readonly FILES_COUNT=${4}
  readonly FILE_CHARS=$(echo ${5} | awk -F. '{print $1}')
  readonly FILE_EXTENSION=$(echo ${5} | awk -F. '{print $2}')
  readonly INPUT_SIZE=${6}
  readonly FILE_SIZE=$((${6::-2} * 1024))

  input_information ${5} ${6}

  source ${SCRIPT_DIR}/generate_files.sh
  generate_files_and_folders

  output_result
}

main $@