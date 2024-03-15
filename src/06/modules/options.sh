#!/bin/bash

sort_and_filters() {
  local log_path=$(cd ${SCRIPT_DIR} && cd ./../04/logs && pwd)
  local logs=$(ls ${log_path}/*.log)
  local count=0
  local flags

  rm -rf ${SCRIPT_DIR}/reports
  mkdir -p ${SCRIPT_DIR}/reports

  case ${1} in
    1) flags="--sort-panel=HTTPStatus" ;;
    2) flags="--unique-visitors" ;;
    3) flags="--http-status-codes=4xx,5xx" ;;
    4) flags="--http-status-codes=4xx,5xx --unique-visitors" ;;
  esac

  for log in ${logs}; do
    local html_name="${SCRIPT_DIR}/reports/access_$((count + 1)).html"

    generate_status ${count}

    goaccess -f ${log} --log-format=COMBINED ${FLAGS} -o ${html_name} > /dev/null 2>&1
    
    ((count++))
    generate_status ${count}
  done
}