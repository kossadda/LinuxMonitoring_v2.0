#!/bin/bash

ip() {
  local ip=$((RANDOM % (255 - 1) + 1))
  while [[ ${ip} -eq 127 ]]; do
    ip=$((RANDOM % (255 - 1) + 1))
  done

  for ((i = 0; i < 3; i++)); do
    ip="${ip}.$((RANDOM % 255))"
  done

  echo ${ip}
}

error() {
  local -r errors=("200" "201" "400" "401" "403" "404" "500" "501" "502" "503")
  local -r index=$((RANDOM % 10))

  echo ${errors[${index}]}
}

method() {
  local -r methods=("GET" "POST" "PUT" "PATCH" "DELETE")
  local -r index=$((RANDOM % 5))

  echo ${methods[${index}]}
}

dates() {
  local -r start=$(date -d "1 year ago" +"%Y-%m-%d")
  local -r end=$(date +"%Y-%m-%d")

  local -r timestamp=$(shuf -i $(date -d "${start}" +"%s")-$(date -d "${end}" +"%s") -n 1)
  local -r random_date=$(date -d @${timestamp} +"%Y-%m-%d")

  echo ${random_date}
}









