#!/bin/bash

validation() {
    code=0
    if [ $# -lt 1 ] || [ $# -gt 6 ]; then
        echo "Enter 6 parameters:"
        echo "1) Absolute path"
        echo "2) Number of subfolders"
        echo "3) Letters in folder names"
        echo "4) Number of files in each folder"
        echo "5) Letters in file names"
        echo "6) File size in kilobytes"
        code=1
    else
        if ! [[ "$1" =~ ^/.*\/$ ]]; then
            echo "Parameter 1: absolute path - starts(ends) with \"/\"  |  example: /home/"
            code=1
        else
            if [[ ! -d "$1" ]] && [[ $1 == */ ]]; then
                echo "Parameter 1: This directory does not exist"
                code=1
            fi
        fi
        if ! [[ "$2" =~ ^[0-9]+$ ]]; then
            echo "Parameter 2: number of subfolders - integer  |  example: 5"
            code=1
        fi
        if ! [[ "$3" =~ ^[a-zA-Z]{1,7}$ ]]; then
            echo "Parameter 3: letters in folder names - string, length [1-7]  |  example: abc)"
            code=1
        fi
        if ! [[ "$4" =~ ^[0-9]+$ ]]; then
            echo "Parameter 4: number of files in each folder - integer  |  example: 3"
            code=1
        fi
        if ! [[ "$5" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
            echo "Parameter 5: letters in file names - string, filename length [1-7], file format length [1-3]  |  example: abc.xz"
            code=1
        fi
        if ! [[ "$6" =~ ^[0-9]+kb$ ]] || [ $trimmed_size -gt 100 ]; then
            echo "Parameter 6: file size in kilobytes - integer, range [0-100]  |  example: 15kb"
            code=1
        fi
    fi
    return $code
}