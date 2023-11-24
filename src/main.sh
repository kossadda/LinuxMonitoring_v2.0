#!/bin/bash

PATH=$1
NEST=$2
CHAR=$3
FNUM=$4
FCHAR=$5
SIZE=$6

source ./valid.sh
if [ $(valid) -eq 1 ]; then
    echo "Govno"
fi

# # Используем значения, переданные через аргументы командной строки
# input="$1"
# len="$2"

# # Вызываем функцию
# test=$(random_str "$input" "$len")

# # Выводим результат
# echo "Random string: $test"
