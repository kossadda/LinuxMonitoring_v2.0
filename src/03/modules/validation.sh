#!/bin/bash

validation() {
  local code=0

  echo -e ${YELLOW}
  if [[ $# -ne 1 ]]; then
    echo -e "Entered ${RED}$#${YELLOW} parameters. Enter configuration in ${GREEN}user_input.conf${YELLOW} and ${GREEN}1${YELLOW} parameter, integer [1-3]:\n"
    echo -e "Method 1: clean by log file. Absolute or relative path to report.log.   ${GREEN}Example: ../02/report.log${YELLOW}"
    echo -e "Method 2: clean by time of creating. Time of start and end of creating. ${GREEN}Example: $(date '+%Y-%m-%d %H:%M')${YELLOW}"
    echo -e "Method 3: clean by name mask. File and folders name mask.               ${GREEN}Example: folder_120324 file_120324.txt${YELLOW}"
    code=1
  else
    if [[ ! ${1} =~ ^[1-3]$ ]]; then
      echo -e "Invalid ${RED}${1}${YELLOW} number of method. Need integer [1-3]. ${GREEN}Example: 1${YELLOW}"
      code=1
    else
      source ${SCRIPT_DIR}/user_input.conf
      if [[ ${1} -eq 1 ]]; then
        check_logfile
      elif [[ ${1} -eq 2 ]]; then
        check_date_and_time "START_CREATE" ${START_CREATE}
        if [[ $? -eq 1 ]]; then
          code=1
        fi
        check_date_and_time "END_CREATE" ${END_CREATE}
        if [[ $? -eq 0 ]] && [[ ${code} -eq 0 ]]; then
          if [[ $(date -d "${START_CREATE}" "+%s") -gt $(date -d "${END_CREATE}" "+%s") ]]; then
            echo "START_CREATE date is greater than END_CREATE"
            code=1
          fi
        fi
      elif [[ ${1} -eq 3 ]]; then 
        check_mask
      fi

      if [[ $? -eq 1 ]]; then
        code=1
      fi
    fi
  fi
  echo -en ${RESET}

  return $code
}

check_logfile() {
  local code=0

  if [[ ! -z ${CLEAN_REPORT_PATH} ]] && [[ ${CLEAN_REPORT_PATH} =~ ^(.*)?report\.log ]] ; then
    cd ${SCRIPT_DIR}
    if [[ ! -e ${CLEAN_REPORT_PATH} ]]; then
      echo -e "File ${GREEN}${CLEAN_REPORT_PATH}${YELLOW} does not exist"
      code=1
    fi
  else
    echo -e "Enter path to ${GREEN}report.log${YELLOW} in ${RED}${SCRIPT_DIR}/user_input.conf${YELLOW}"
    code=1
  fi

  return ${code}
}

check_date_and_time() {
  local date="${2}"
  local time="${3}"
  local code=0

  if [[ ! -z ${date} ]] && [[ ! -z ${time} ]]; then
    if [[ ${date} =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && [[ ${time} =~ ^[0-9]{2}:[0-9]{2}$ ]]; then
      local mistake_date=0
      local mistake_time=0

      if ! date -d ${date} &> /dev/null; then
        mistake_date=1
      fi
      if ! date -d ${time} +%H:%M &> /dev/null; then
        mistake_time=1
      fi
      
      if [[ ${mistake_date} -eq 1 ]] && [[ ${mistake_time} -eq 1 ]]; then
        echo -e "${1}: incorrect date and time ${RED}${check}${YELLOW}"
        code=1
      elif [[ ${mistake_date} -eq 1 ]]; then
        echo -e "${1}: incorrect date ${RED}${date} ${GREEN}${time}${YELLOW}"
        code=1
      elif [[ ${mistake_time} -eq 1 ]]; then
        echo -e "${1}: incorrect time ${GREEN}${date} ${RED}${time}${YELLOW}"
        code=1
      fi
    else
      echo -e "${1}: incorrect format of date ${RED}${date} ${time}${YELLOW}. ${GREEN}Example: $(date '+%Y-%m-%d %H:%M')${YELLOW}"
      code=1
    fi
  else
    echo -e "${1}: enter parameter in ${RED}user_input.conf${YELLLOW}. ${GREEN}Example: $(date '+%Y-%m-%d %H:%M')${YELLOW}"
    code=1
  fi

  return ${code}
}

check_mask() {
  local code=0

  if [[ ! -z ${FOLDER_MASK} ]]; then
    if [[ ! ${FOLDER_MASK} =~ ^[a-zA-Z]{1,7}_[0-9]{6}$ ]]; then
      echo -e "FOLDER_MASK: incorrect format of folder mask. ${GREEN}Example: folder_120324${YELLOW}"
      code=1
    fi
  else
    echo -e "FOLDER_MASK: enter parameter in ${RED}user_input.conf${YELLLOW}. ${GREEN}Example: folder_120324${YELLOW}"
    code=1
  fi

  if [[ ! -z ${FILE_MASK} ]]; then
    if [[ ! ${FILE_MASK} =~ ^[a-zA-Z]{1,7}_[0-9]{6}.[a-zA-Z]{1,3}$ ]]; then
      echo -e "FILE_MASK: incorrect format of file mask.     ${GREEN}Example: file_120324.txt${YELLOW}"
      code=1
    fi
  else
    echo -e "FILE_MASK: enter parameter in ${RED}user_input.conf${YELLLOW}.   ${GREEN}Example: file_120324.txt${YELLOW}"
    code=1
  fi

  return ${code}
}