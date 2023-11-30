#!/bin/bash

path=:"$(pwd)"

if [ $# != 0 ] ; then
    echo "No arguments required"
    exit 1
fi

system_information() {
    CPU=$(mpstat 1 2 | awk 'NR==4 {print 100 - $12}')
    Space_Total=$(df / | awk 'NR==2 {print $2}')
    Space_Used=$(df / | awk 'NR==2 {print $3}')
    Space_Free=$(df / | awk 'NR==2 {print $4}')
    RAM_Total=$(free | awk '/Mem/ {print $2}')
    RAM_Free=$(free | awk '/Mem/ {print $4}')
    Total_IOs=$(vmstat 1 2 | awk 'NR==3 {print $10 + $11}')

    echo "CPU $CPU" | sudo tee index.html > /dev/null
    echo "Space_Total $Space_Total" | sudo tee -a index.html > /dev/null
    echo "Space_Used $Space_Used" | sudo tee -a index.html > /dev/null
    echo "Space_Free $Space_Free" | sudo tee -a index.html > /dev/null
    echo "RAM_Total $RAM_Total" | sudo tee -a index.html > /dev/null
    echo "RAM_Free $RAM_Free" | sudo tee -a index.html > /dev/null
    echo "Total_IOs $Total_IOs" | sudo tee -a index.html > /dev/null
}

main_node_exporter() {
    sudo touch index.html
    while true; do
        system_information
        sleep 3
    done;
}

main_node_exporter