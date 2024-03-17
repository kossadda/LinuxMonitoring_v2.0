#!/bin/bash

sort_and_filters() {
  local log_path=$(cd ${SCRIPT_DIR} && cd ./../04/logs && pwd)
  local logs=$(ls ${log_path}/*.log)
  local count=0
  local flags

  rm -rf ${SCRIPT_DIR}/reports
  mkdir -p ${SCRIPT_DIR}/reports

  case ${1} in
    1) flags="--sort-panel=STATUS_CODES,BY_DATA,ASC" ;;
    2) flags="--sort-panel=HOSTS,BY_DATA,ASC" ;;
    3) flags="--ignore-status=200 --ignore-status=201" ;;
    4) flags="--ignore-status=200 --ignore-status=201 --sort-panel=HOSTS,BY_DATA,ASC" ;;
  esac

  for log in ${logs}; do
    local html_name="${SCRIPT_DIR}/reports/access_$((count + 1)).html"

    generate_status ${count}

    goaccess -f ${log} --log-format=COMBINED ${flags} -o ${html_name} > /dev/null 2>&1
    
    ((count++))
    generate_status ${count}
  done
}