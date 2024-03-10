#!/bin/bash

validation() {
  local code=0

  echo -e ${YELLOW}
  if [[ $# -lt 1 ]] || [[ $# -gt 3 ]]; then
    echo -e "Entered ${RED}$#${YELLOW} parameters. Enter ${GREEN}3${YELLOW} parameters:\n"
    echo -e "Parameter 1: letters in folder names - string, length [1-7]. ${GREEN}Example: az${YELLOW}"
    echo -e "Parameter 2: letters in file names - string, file name length [1-7], file extension length [1-3]. ${GREEN}Example: az.az${YELLOW}"
    echo -e "Parameter 3: file size in megabytes - integer, range [0-100]. ${GREEN}Example: 3Mb${YELLOW}"
    code=1
  else
    if ! [[ "$1" =~ ^[a-zA-Z]{1,7}$ ]]; then
      echo -e "Invalid ${RED}${1}${YELLOW} letters in folder names. Need string, length [1-7]. ${GREEN}Example: az${YELLOW}"
      code=1
    fi

    if ! [[ "$2" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
      echo -e "Invalid ${RED}${2}${YELLOW} letters in file names. Need string, name length [1-7], extension length [1-3]. ${GREEN}Example: az.az${YELLOW}"
      code=1
    fi

    if ! [[ "$3" =~ ^[0-9]+Mb$ ]] || [[ ${3::-2} -gt 100 ]] || [[ ${3::-2} -eq 0 ]]; then
      echo -e "Invalid ${RED}${3}${YELLOW} file size. Need integer, range [1-100]. ${GREEN}Example: 3Mb${YELLOW}"
      code=1
    fi
  fi
  echo -en ${RESET}

  return $code
}
