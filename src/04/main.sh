#!/bin/bash

# Указываем директорию для сохранения логов
log_dir="./logs"

# Создаем директорию, если её нет
mkdir -p $log_dir

# Цикл по каждому из 5 дней
for day in {1..5}
do
    echo "Create log for $day day..."
    
    # Генерируем случайное количество записей от 100 до 1000
    num_entries=$((RANDOM % 901 + 100))
    
    # Генерируем лог файл для текущего дня
    log_file="$log_dir/access.log.$day"
    
    # Генерируем случайные записи
    for ((i=0; i<$num_entries; i++))
    do
        # Генерируем случайный IP-адрес с использованием apache2-utils
        ip_address=$(head -n 1 /dev/urandom | md5sum | awk '{print $1}' | sed 's/\(.\{3\}\)/\1./g' | sed 's/\.$//')

        # Генерируем случайный код ответа
        status_code=$((RANDOM % 10))
        case $status_code in
            0) status_code=200 ;;   # OK
            1) status_code=201 ;;   # Created
            2) status_code=400 ;;   # Bad Request
            3) status_code=401 ;;   # Unauthorized
            4) status_code=403 ;;   # Forbidden
            5) status_code=404 ;;   # Not Found
            6) status_code=500 ;;   # Internal Server Error
            7) status_code=501 ;;   # Not Implemented
            8) status_code=502 ;;   # Bad Gateway
            9) status_code=503 ;;   # Service Unavailable
        esac

        # Генерируем случайный метод
        methods=("GET" "POST" "PUT" "PATCH" "DELETE")
        method=${methods[$((RANDOM % 5))]}

        # Генерируем случайную дату в формате "дд/ММ/гггг:чч:мм:сс +0000"
        date=$(date -d "2023-01-01 +$day days $((RANDOM % 24)) hours $((RANDOM % 60)) minutes $((RANDOM % 60)) seconds" "+%d/%b/%Y:%H:%M:%S +0000")

        # Генерируем случайный URL запроса агента
        url="/path/$((RANDOM % 10))"

        # Генерируем случайного агента
        agents=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler and bot" "Library and net tool")
        agent=${agents[$((RANDOM % 8))]}

        # Формируем строку лога и записываем её в файл
        log_entry="$ip_address - - [$date] \"$method $url\" $status_code 0 \"-\" \"$agent\""
        echo $log_entry >> $log_file
    done
done

echo "Log files were successfully created"