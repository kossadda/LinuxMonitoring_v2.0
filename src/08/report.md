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
