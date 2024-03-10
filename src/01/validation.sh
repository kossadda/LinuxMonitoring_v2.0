#!/bin/bash

validation() {
  local code=0

  echo -e ${YELLOW}
  if [[ $# -lt 1 ]] || [[ $# -gt 6 ]]; then
    echo -e "Entered $# parameters. Enter 6 parameters:\n"
    echo "Parameter 1: absolute path - starts with \"/\". Example: /home"
    echo "Parameter 2: number of subfolders - integer. Example: 5"
    echo "Parameter 3: letters in folder names - string, length [1-7]. Example: abcd"
    echo "Parameter 4: number of files in each folder - integer. Example: 15"
    echo "Parameter 5: letters in file names - string, filename length [1-7], file extension length [1-3]. Example: abc.xz"
    echo "Parameter 6: file size in kilobytes - integer, range [0-100]. Example: 15kb"
    code=1
  else
    if ! [[ ${1} =~ ^/.*$ ]]; then
      echo "Parameter 1: absolute path - starts with \"/\". Example: /home"
      code=1
    else 
      if ! [[ -d ${1} ]]; then
        echo "Parameter 1: folder ${1} does not exist"
        code=1
      fi
    fi
    
    if ! [[ ${2} =~ ^[0-9]+$ ]]; then
      echo "Parameter 2: number of subfolders - integer. Example: 5"
      code=1
    fi

    if ! [[ "$3" =~ ^[a-zA-Z]{1,7}$ ]]; then
      echo "Parameter 3: letters in folder names - string, length [1-7]. Example: abcd"
      code=1
    fi

    if ! [[ "$4" =~ ^[0-9]+$ ]]; then
      echo "Parameter 4: number of files in each folder - integer. Example: 15"
      code=1
    fi

    if ! [[ "$5" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
      echo "Parameter 5: letters in file names - string, filename length [1-7], file extension length [1-3]. Example: abc.xz"
      code=1
    fi

    if ! [[ "$6" =~ ^[0-9]+kb$ ]] || [[ ${6::-2} -gt 100 ]] || [[ ${6::-2} -eq 0 ]]; then
      echo "Parameter 6: file size in kilobytes - integer, range [1-100]. Example: 15kb"
      code=1
    fi
  fi
  echo -en ${RESET}

  return $code
}
