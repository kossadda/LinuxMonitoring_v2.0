#!/bin/bash

main() {
  readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  source ${SCRIPT_DIR}/modules/configuration.conf

  source ${SCRIPT_DIR}/modules/dialog.sh
  input_information ${1}

  source ${SCRIPT_DIR}/modules/generate_logs.sh
  
  generate_logs

  output_result
}

main $@
