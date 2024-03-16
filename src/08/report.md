# Part 8. Готовый дашборд

**Установить готовый дашборд Node Exporter Quickstart and Dashboard с официального сайта Grafana Labs**

## Установка Node Exporter

- Загрузить инструмент Node Exporter:

`wget https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz` <br>

- Извлечь файлы:

`tar xvfz node_exporter-1.2.2.linux-amd64.tar.gz` <br>

- Создать Node Exporter Serve:

`sudo vim /etc/systemd/system/node_exporter.service` <br>
>[Unit] <br>
Description=Node Exporter <br>
Wants=network-online.target <br>
After=network-online.target <br>
[Service] <br>
User=node_exporter <br>
Group=node_exporter <br>
Type=simple <br>
ExecStart=/usr/local/bin/node_exporter <br>
[Install] <br>
WantedBy=multi-user.target <br>

- Перезагрузить systemd и запустить службу Node Exporter:

`sudo systemctl daemon-reload` <br>
`sudo systemctl start node_exporter` <br>
`sudo systemctl status node_exporter` <br>

<img src="./../../misc/images/part_8/1.jpg" alt="1" />

- Проверить работу порта:

<img src="./../../misc/images/part_8/2.jpg" alt="2" />

- Добавить Node Exporter в цели Prometheus'а:

<img src="./../../misc/images/part_8/3.jpg" alt="3" />

- Проверить появились ли метрики Node Exporter в целях Prometheus'а:

<img src="./../../misc/images/part_8/4.jpg" alt="4" />

## Создание собственного dashboard'а

- Перейти на страницу *GrafanaLabs* в категорию *Dashboards*:

<img src="./../../misc/images/part_8/5.jpg" alt="5" />

- Выбрать из списка *Node Exporter Quickstart and Dashboard* и загрузить файл JSON нажав на *Download JSON*:

<img src="./../../misc/images/part_8/6.jpg" alt="6" />

- В Grafana в разделе *Dashboards* нажать на кнопку *Import a dashboard*:

<img src="./../../misc/images/part_8/7.jpg" alt="7" />

- Копировать содержимое JSON файла или выбрать его нажав *Upload dashboar JSON file* и нажать *Load*:

<img src="./../../misc/images/part_8/8.jpg" alt="8" />

- Вид готового dashboard'а:

<img src="./../../misc/images/part_8/9.jpg" alt="9" />

**Провести те же тесты, что и в Части 7**

- Создание мусора:

<img src="./../../misc/images/part_8/10.jpg" alt="10" />

- Очистка мусора:

<img src="./../../misc/images/part_8/11.jpg" alt="11" />

- Запустить команду stress и посмотреть на нагрузку жесткого диска, оперативной памяти и ЦПУ:

`stress -c 2 -i 1 -m 1 --vm-bytes 32M -t 60s` <br>
<img src="./../../misc/images/part_8/12.jpg" alt="12" />

## Статическая маршрутизация между двумя машинами

**1 машина:** `sudo vim /etc/netplan/00-network-manager-all.yaml` <br>
<img src="./../../misc/images/part_8/13.jpg" alt="13" />

**2 машина:** `sudo vim /etc/netplan/00-network-manager-all.yaml` <br>
<img src="./../../misc/images/part_8/14.jpg" alt="14" />

**1 машина:** `ping 172.24.116.8 -c 5` <br>
<img src="./../../misc/images/part_8/15.jpg" alt="15" />

**2 машина:** `ping 192.168.100.10 -c 5` <br>
<img src="./../../misc/images/part_8/16.jpg" alt="16" />

- Для удобства ограничить отображение метрик на dashboard, указав единственный необходимый нам адаптер enp0s9 и провести тест нагрузки сетевого соединения при пинговании второй машины:
<img src="./../../misc/images/part_8/17.jpg" alt="17" />
