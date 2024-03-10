#!/bin/bash

generate_name() {
  local addition_count=$((RANDOM % (75 - 4) + 4))
  local name=${1}
  local random_index

  for ((i = 0; i < ${addition_count}; i++)); do
    random_index=$((RANDOM % ${#name}))
    name=${name:0:random_index}${name:random_index:1}${name:random_index:${#name}}
  done

  echo ${name}
}

get_filename() {
  local filename=$(generate_name ${FILE_CHARS})

  echo "${filename}_${DATE}.${FILE_EXTENSION}"
}

get_foldername() {
  local foldername=$(generate_name ${FOLDER_CHARS})

  echo "${foldername}_${DATE}"
}
