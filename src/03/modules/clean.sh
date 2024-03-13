#!/bin/bash

clean() {
  local havent_permission=0
  local not_exist=0
  local folders
  case ${1} in
    1) 
      folders=$(grep "created folder:" ${CLEAN_REPORT_PATH} | awk -F"created folder: " '{print $2}' | tac);;
    2)
      folders=$(find / -type d -newermt "${START_CREATE}" -not -newermt "${END_CREATE}" 2>/dev/null | grep -E "/[^/]*_[0-9]{6}$" | tac);;
    3)
      folders=$(find / -type d -regex $(regular_mask) 2>/dev/null | tac);;
  esac

  for folder in ${folders}; do
    ((FULL_COUNT++))

    if [[ -d ${folder} ]]; then
      if rm -rf ${folder} 2>/dev/null; then
        ((FOLDERS++))
        report_folder_clean ${folder}
        generate_status
      else
        ((havent_permission++))
        report_havent_permission_folder ${folder}
      fi
    else
      ((not_exist++))
      report_not_exist_folder ${folder}
    fi
  done

  if [[ ${not_exist} -ne 0 ]]; then
    echo -e "\n${RED}Warning: ${RED}${not_exist}${YELLOW} from ${RED}${count}${YELLOW} folders does not exist${RESET}"
  fi
  if [[ ${havent_permission} -ne 0 ]]; then
    echo -e "\n${RED}Warning: ${YELLOW}You haven't permission to delete ${RED}${havent_permission}${YELLOW} folders"
    echo -e "Please start script again with sudo${RESET}"
  fi
}

regular_mask() {
  local regular
  local chars=$(echo ${FOLDER_MASK} | awk -F_ '{print $1}')
  local date=$(echo ${FOLDER_MASK} | awk -F_ '{print $2}')

  echo ".*/[${chars}]+_${date}$"
}