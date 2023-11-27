#!/bin/bash

log_file="clean_report.log"

timedate_clean() {

    echo "Введите дату и время создания файлов в таком формате с точностью до минуты: $(date '+%Y-%m-%d %H:%M')"
    
    read -p "Введите время начала создания файлов: " start_time   
    read -p "Введите время конца создания файлов: " end_time
    
    
    sudo find / -newermt "$start_time" -not -newermt "$end_time" 2>/dev/null | while read -r file; do
        # Проверяем, что имя файла оканчивается на _ и 6 цифр
        if [[ $file =~ _[0-9]{6}$ ]]; then
            echo "Удален: $file" >> "$log_file" 
            sudo rm -r "$file" 2>/dev/null
        fi
    done


    echo "Удаление завершено." >> "$log_file"
}


log_clean() {
    local files=""
    local presence=0
    if [ -e "report.log" ]; then
        presence=1
    elif [ -e "../02/report.log" ]; then
        presence=2
    fi
    
    if [ $presence -eq 1 ]; then
        files=$(grep "_[0-9]\{6\}$" report.log | sed 's/Date [0-9.]\+ created folder: //')
    elif [ $presence -eq 2 ]; then
        files=$(grep "_[0-9]\{6\}$" ../02/report.log | sed 's/Date [0-9.]\+ created folder: //')
    fi

    if [ $presence -ne 0 ]; then
        echo "$files"
    else
        echo "The report.log file is missing in directory 02 or 03"
    fi
}

# timedate_clean
log_clean