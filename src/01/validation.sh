#!/bin/bash

validation() {
  local code=0

  echo -e ${YELLOW}
  if [[ $# -lt 1 ]] || [[ $# -gt 6 ]]; then
    echo -e "Entered ${RED}$#${YELLOW} parameters. Enter ${GREEN}6${YELLOW} parameters:\n"
    echo -e "Parameter 1: absolute path - starts with \"/\". ${GREEN}Example: /home${YELLOW}"
    echo -e "Parameter 2: number of subfolders - integer. ${GREEN}Example: 5${YELLOW}"
    echo -e "Parameter 3: letters in folder names - string, length [1-7]. ${GREEN}Example: abcd${YELLOW}"
    echo -e "Parameter 4: number of files in each folder - integer. ${GREEN}Example: 15${YELLOW}"
    echo -e "Parameter 5: letters in file names - string, filename length [1-7], file extension length [1-3]. ${GREEN}Example: abcd.xyz${YELLOW}"
    echo -e "Parameter 6: file size in kilobytes - integer, range [0-100]. ${GREEN}Example: 15kb${YELLOW}"
    code=1
  else
    if ! [[ ${1} =~ ^/.*$ ]]; then
      echo -e "Invalid ${RED}${1}${YELLOW} path. Path starts with \"/\". ${GREEN}Example: /home${YELLOW}"
      code=1
    else 
      if ! [[ -d ${1} ]]; then
        echo -e "Invalid ${RED}${1}${YELLOW} path. Folder ${RED}${1}${YELLOW} does not exist"
        code=1
      elif ! [[ -w ${1} ]]; then
        echo -e "Invalid ${RED}${1}${YELLOW} path. You don't have write permission for ${RED}${1}${YELLOW} folder"
        code=1
      fi
    fi
    
    if ! [[ ${2} =~ ^[0-9]+$ ]]; then
      echo -e "Invalid ${RED}${2}${YELLOW} number of subfolders. Need integer. ${GREEN}Example: 5${YELLOW}"
      code=1
    fi

    if ! [[ "$3" =~ ^[a-zA-Z]{1,7}$ ]]; then
      echo -e "Invalid ${RED}${3}${YELLOW} letters in folder names. Need string, length [1-7]. ${GREEN}Example: abcd${YELLOW}"
      code=1
    fi

    if ! [[ "$4" =~ ^[0-9]+$ ]]; then
      echo -e "Invalid ${RED}${4}${YELLOW} number of files in each folder. Need integer. ${GREEN}Example: 15${YELLOW}"
      code=1
    fi

    if ! [[ "$5" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
      echo -e "Invalid ${RED}${5}${YELLOW} letters in file names. Need string, name length [1-7], extension length [1-3]. ${GREEN}Example: abc.xz${YELLOW}"
      code=1
    fi

    if ! [[ "$6" =~ ^[0-9]+kb$ ]] || [[ ${6::-2} -gt 100 ]] || [[ ${6::-2} -eq 0 ]]; then
      echo -e "Invalid ${RED}${6}${YELLOW} file size. Need integer, range [1-100]. ${GREEN}Example: 15kb${YELLOW}"
      code=1
    fi
  fi
  echo -en ${RESET}

  return $code
}
