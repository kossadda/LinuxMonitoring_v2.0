#!/bin/bash

get_filename() {
  local name=${FILE_CHARS}
  local random_index

  for ((i = 0; i < 248 - ${#FILE_EXTENSION}; i++)); do
    random_index=$((RANDOM % ${#name}))
    name=${name:0:random_index}${name:random_index:1}${name:random_index:${#name}}
    if [[ ${#name} -ge 4 ]] && [[ ! -e "${1}/${name}_${DATE}.${FILE_EXTENSION}" ]]; then
      break
    fi
  done

  echo "${name}_${DATE}.${FILE_EXTENSION}"
}

get_foldername() {
  local name=${FOLDER_CHARS}
  local random_index

  for ((i = 0; i < 248; i++)); do
    random_index=$((RANDOM % ${#name}))
    name=${name:0:random_index}${name:random_index:1}${name:random_index:${#name}}
    if ! [[ -d "${1}/${name}_${DATE}" ]]; then
      break
    fi
  done

  echo "${name}_${DATE}"
}
