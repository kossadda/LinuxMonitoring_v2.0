#!/bin/bash

timedate_clean() {
    log_file="logrm.txt"

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

timedate_clean