#!/bin/bash

sort_and_filters() {
  local log_path=$(cd ${SCRIPT_DIR} && cd ./../04/logs && pwd)
  local logs=$(ls ${log_path}/*.log)
  local count=0

  rm -rf sort_logs
  mkdir -p sort_logs

  for log in ${logs}; do
    local sort_log_name="${SCRIPT_DIR}/sort_logs/$(basename ${log})"
    
    generate_status ${count}

    {
      case ${1} in
        1) awk '{print $0}' ${log} | sort -k12,12n ;;
        2) awk '{print $1}' ${log} ;;
        3) awk '$12 ~ /^4|^5/' ${log} ;;
        4) awk '$12 ~ /^4|^5/' ${log} | awk '{print $1}' | sort -u ;;
      esac
    } >> ${sort_log_name}
    
    ((count++))
    generate_status ${count}
  done
}