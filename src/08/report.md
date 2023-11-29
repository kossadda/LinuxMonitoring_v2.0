# Part 8. Готовый дашборд

**Установить готовый дашборд Node Exporter Quickstart and Dashboard с официального сайта Grafana Labs**

## Установка Node Exporter

- Загрузить инструмент Node Exporter:

`wget https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz` <br>

- Извлечь файлы:

`tar xvfz node_exporter-1.2.2.linux-amd64.tar.gz` <br>

- Создать Node Exporter Serve:

`sudo vim /etc/systemd/system/node_exporter.service` <br>
>[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
[Install]
WantedBy=multi-user.target

- Перезагрузить systemd и запустить службу Node Exporter:

`sudo systemctl daemon-reload` <br>
`sudo systemctl start node_exporter` <br>
`sudo systemctl status node_exporter` <br>

## Создание собственного dashboard'а

- Перейти на страницу *GrafanaLabs* в категорию *Dashboards* и выбрать из списка *Node Exporter Full*:

<img src="../../misc/images/part_8/1.jpg" alt="1" />

- Загрузить файл JSON нажав на *Download JSON*:

<img src="../../misc/images/part_8/2.jpg" alt="2" />

- В Grafana в разделе *Dashboards* нажать на кнопку *Import*:

<img src="../../misc/images/part_8/3.jpg" alt="3" />

- Копировать содержимое JSON файла в окно *Import via panel json* и нажать *Load*:

<img src="../../misc/images/part_8/4.jpg" alt="4" />

**Провести те же тесты, что и в Части 7**

- Создание мусора:

<img src="../../misc/images/part_8/5.jpg" alt="5" />

- Очистка мусора:

<img src="../../misc/images/part_8/6.jpg" alt="6" />

- Запустить команду stress и посмотреть на нагрузку жесткого диска, оперативной памяти и ЦПУ:

`stress -c 2 -i 1 -m 1 --vm-bytes 32M -t 60s` <br>
<img src="../../misc/images/part_8/7.jpg" alt="7" />

**Связать две виртуальные машины**

**1 машина:** `sudo vim /etc/sysconfig/network-scripts/ifcfg-enp0s8`
>TYPE=Ethernet
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
NAME=enp0s8
UUID=уникальный_UUID_для_машины_1
DEVICE=enp0s8
ONBOOT=yes
IPADDR=192.168.2.1
PREFIX=24
GATEWAY=192.168.2.254
DNS1=8.8.8.8
`sudo nmcli connection add con-name "enp0s8" ifname enp0s8 type ethernet UUID_MACHINE_1=$(uuidgen)`
`sudo nmcli connection modify enp0s8 ipv4.addresses 192.168.2.1/24 ipv4.gateway 192.168.2.254`
`sudo nmcli connection modify enp0s8 ipv4.method manual`
`sudo nmcli connection modify enp0s8 connection.uuid $UUID_MACHINE_1`


**2 машина:** `sudo vim /etc/sysconfig/network-scripts/ifcfg-enp0s8`
>TYPE=Ethernet
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
NAME=enp0s8
UUID=уникальный_UUID_для_машины_2
DEVICE=enp0s8
ONBOOT=yes
IPADDR=192.168.2.2
PREFIX=24
GATEWAY=192.168.2.254
DNS1=8.8.8.8
`sudo nmcli connection add con-name "enp0s8" ifname enp0s8 type ethernet UUID_MACHINE_2=$(uuidgen)`
`sudo nmcli connection modify enp0s8 ipv4.addresses 192.168.2.2/24 ipv4.gateway 192.168.2.254`
`sudo nmcli connection modify enp0s8 ipv4.method manual`
`sudo nmcli connection modify enp0s8 connection.uuid $UUID_MACHINE_2`

**1 машина:** `ping 192.168.2.1` <br>
<img src="../../misc/images/part_8/8.jpg" alt="8" />

**2 машина:** `ping 192.168.2.2` <br>
<img src="../../misc/images/part_8/9.jpg" alt="9" />

- Запустить тест нагрузки сети с помощью утилиты iperf3

**1 машина:** `iperf3 -c 192.168.2.1` <br>
<img src="../../misc/images/part_8/10.jpg" alt="10" />

**2 машина:** `iperf3 -s` <br>
<img src="../../misc/images/part_8/11.jpg" alt="11" />

- Посмотреть на нагрузку сетевого интерфейса:

<img src="../../misc/images/part_8/12.jpg" alt="12" />