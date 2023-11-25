#!/bin/bash

validation() {
    code=0
    if [ $# -lt 1 ] || [ $# -gt 3 ]; then
        echo "Enter 3 parameters:"
        echo "1) Letters in folder names"
        echo "2) Letters in file names"
        echo "3) File size in megabytes"
        code=1
    else
        if ! [[ "$1" =~ ^[a-zA-Z]{1,7}$ ]]; then
            echo "Parameter 1: letters in folder names - string, length [1-7]  |  example: abc)"
            code=1
        fi
        if ! [[ "$2" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]]; then
            echo "Parameter 2: letters in file names - string, filename length [1-7], file format length [1-3]  |  example: abc.xz"
            code=1
        fi
        if ! [[ "$3" =~ ^[0-9]+Mb$ ]] || [ $trimmed_size -gt 100 ]; then
            echo "Parameter 3: file size in megabytes - integer, range [0-100]  |  example: 15Mb"
            code=1
        fi
    fi
    return $code
}