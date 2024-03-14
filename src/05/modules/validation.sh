#!/bin/bash

validation() {
  local code=0

  echo -e ${YELLOW}
  if [[ $# -ne 1 ]]; then
    echo -e "Entered ${RED}$#${YELLOW} parameters. Enter ${GREEN}1${YELLOW} parameter, integer [1-4]:\n"
    echo -e "1) Sort: by response code"
    echo -e "2) Filter: unique IPs found in records"
    echo -e "3) Filter: requests with errors (response code - 4xx or 5xx)"
    echo -e "4) Filter: unique IPs that are found among erroneous requests"
    code=1
  else
    if [[ ! ${1} =~ ^[1-4]$ ]]; then
      echo -e "Invalid ${RED}${1}${YELLOW} number of method. Need integer [1-4]. ${GREEN}Example: 1${YELLOW}"
      code=1
    else
      check_logfile
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
  local task_dir="$(cd ${SCRIPT_DIR} && cd ./../04 && pwd)"

  if [[ ! -d "${task_dir}/logs" ]]; then
    echo -e "Can't find dir ${RED}\"logs\"${YELLOW} in ${RED}${task_dir}${YELLOW}"
    code=1
  else
    if ! ls $task_dir/logs/*.log &>/dev/null; then
      echo -e "There are no log files in ${RED}${task_dir}/logs${YELLOW}"
      code=1
    fi
  fi

  return ${code}
}
