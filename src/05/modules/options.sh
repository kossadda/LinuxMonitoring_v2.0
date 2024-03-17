#!/bin/bash

sort_and_filters() {
  local log_path=$(cd ${SCRIPT_DIR} && cd ./../04/logs && pwd)
  local logs=$(ls ${log_path}/*.log)
  local count=0

  rm -rf ${SCRIPT_DIR}/sort_logs
  mkdir -p ${SCRIPT_DIR}/sort_logs

  for log in ${logs}; do
    local sort_log_name="${SCRIPT_DIR}/sort_logs/$(basename ${log})"
    
    generate_status ${count}

    {
      case ${1} in
        1) awk '{print $0}' ${log} | sort -k8,8n ;;
        2) awk '{print $1}' ${log} | sort -u | sort -k1,1n ;;
        3) awk '$8 ~ /^4|^5/' ${log} | sort -k8,8n ;;
        4) awk '$8 ~ /^4|^5/' ${log} | awk '{print $1}' | sort -u | sort -k1,1n ;;
      esac
    } >> ${sort_log_name}
    
    ((count++))
    generate_status ${count}
  done
}