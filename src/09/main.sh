#!/bin/bash

sys_info() {
  local -r CPU=$(top -bn 1 | grep "^%Cpu(s)" | awk '{printf "%d", $2 + $4}')
  local -r Space_Total=$(df | grep /$ | awk '{print $2}')
  local -r Space_Used=$(df | grep /$ | awk '{print $3}')
  local -r Space_Free=$(df | grep /$ | awk '{print $4}')
  local -r RAM_Total=$(free | grep ^Mem | awk '{print $2}')
  local -r RAM_Used=$(free | grep ^Mem | awk '{print $3}')
  local -r RAM_Free=$(free | grep ^Mem | awk '{print $4}')

  echo "CPU ${CPU}"
  echo "Space_Total ${Space_Total}"
  echo "Space_Used ${Space_Used}"
  echo "Space_Free ${Space_Free}"
  echo "RAM_Total ${RAM_Total}"
  echo "RAM_Used ${RAM_Used}"
  echo "RAM_Free ${RAM_Free}"
}

main() {
  touch index.html
  
  while true; do
    sys_info > ./index.html
    sleep 3
  done;
}

main
