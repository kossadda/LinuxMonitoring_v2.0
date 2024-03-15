#!/bin/bash

generate_logs() {
  rm -rf ${SCRIPT_DIR}/logs
  mkdir -p ${SCRIPT_DIR}/logs

  for day in {1..5}; do
    local current_log="${SCRIPT_DIR}/logs/access_${day}.log"
    local records=$((RANDOM % (1000 - 100) + 100))
    local iterate_date=$(dates)
    
    generate_status $((day - 1))
    for ((i = 0; i < ${records}; i++)); do
      echo "$(ips) - - [${iterate_date}:$(times)] \"$(methods) $(urls)\" $(errors) $((RANDOM % 1000)) \"$(hosts)\" \"$(agents)\"" >> ${current_log}
    done
    generate_status ${day}

    (awk -F'[][]' '{print $1 "[" $2 "]" $3}' ${current_log} | sort -k4,4 -k2M -k3,3n -k4,4 -k5) > ${SCRIPT_DIR}/logs/tmp.log
    mv ${SCRIPT_DIR}/logs/tmp.log ${current_log}
  done
}

ips() {
  local ip=$((RANDOM % (255 - 1) + 1))
  while [[ ${ip} -eq 127 ]]; do
    ip=$((RANDOM % (255 - 1) + 1))
  done

  for ((i = 0; i < 3; i++)); do
    ip="${ip}.$((RANDOM % 255))"
  done

  echo ${ip}
}

#200 - OK: successful request
#201 - Created: The resource was successfully created
#400 - Bad Request: Invalid request
#401 - Unauthorized: Unauthorized request
#403 - Forbidden: Access denied
#404 - Not Found: Resource not found
#500 - Internal Server Error: Internal server error
#501 - Not Implemented: Not implemented
#502 - Bad Gateway: Bad Gateway
#503 - Service Unavailable: Service unavailable
errors() {
  local -r errors=("200" "201" "400" "401" "403" "404" "500" "501" "502" "503")

  echo ${errors[$((RANDOM % 10))]}
}

# GET - requests data from a specific resource
# POST - sends data for processing to a specific resource
# PUT - updates data on a specific resource or creates a new resource if it does not exist
# PATCH - partially updates data on a specific resource
# DELETE - deletes a specific resource
methods() {
  local -r methods=("GET" "POST" "PUT" "PATCH" "DELETE")

  echo ${methods[$((RANDOM % 5))]}
}

dates() {
  local -r date=$(LC_TIME=en_US.UTF-8 date -d "1 year ago + $((RANDOM % 365)) days" "+%d/%b/%Y")

  echo ${date}
}

times() {
  local -r time=$(date -d "$((RANDOM % 24)) hours $((RANDOM % 60)) minutes $((RANDOM % 60)) seconds" "+%H:%M:%S %Z")

  echo ${time}
}

hosts() {
  local -r hosts=("ex.com" "test.org" "website.net" "google.com" "ya.ru" "hosts.com" "memes.ru")
  local -r protocols=("http" "https")

  local -r protocol=${protocols[$((RANDOM % ${#protocols[@]}))]}
  local -r host=${hosts[$((RANDOM % ${#hosts[@]}))]}

  echo "${protocol}://${host}"
}

urls() {
  local -r paths=("/page1" "/page2" "/section/page3" "/groups" "/pages/section" "/lists" "/main")

  local -r query_param="param${RANDOM}=value${RANDOM}&param${RANDOM}=value${RANDOM}"
  local -r path=${paths[$((RANDOM % ${#paths[@]}))]}

  echo "${path}?${query_param}"
}

agents() {
  local -r oper_sys=("Windows" "Linux" "iOS" "Android" "X11")
  local -r versions=("1.0" "1.3" "3.5" "4.3" "5.0" "5.9" "7.2" "8.6" "9.4" "10.0" "11.8" "12.5" "13.2" "14.1")
  local -r agents=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler and bot" "Library and net tool")
  
  local -r sys=${oper_sys[$((RANDOM % 5))]}
  local -r ver=${versions[$((RANDOM % 14))]}
  local -r agent=${agents[$((RANDOM % 8))]}

  echo "${agent}/${ver} (${sys})"
}
