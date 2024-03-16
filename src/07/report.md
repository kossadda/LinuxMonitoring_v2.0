# Part 7. Prometheus и Grafana

**Установить и настроить Prometheus и Grafana на виртуальную машину**

## Установка Grafana

- Устанавить пакеты adduser, libfontconfig1 и musl в системе: <br>
`sudo apt-get install -y adduser libfontconfig1 musl`

- Загрузить инструмент grafana с официального сайта: <br>
`wget https://dl.grafana.com/enterprise/release/grafana-enterprise_10.4.0_amd64.deb`

- Установить загруженный пакет: <br>
`sudo dpkg -i grafana-enterprise_10.4.0_amd64.deb`

- Перезагрузить systemd и запустить службу Grafana:

`sudo systemctl daemon-reload` <br>
`systemctl start grafana-server.service` <br>
`systemctl status grafana-server.service` <br>

<img src="./../../misc/images/part_7/1.jpg" alt="1" />

- Проверить работу порта:

<img src="./../../misc/images/part_7/2.jpg" alt="2" />

## Установка Prometheus

- Загрузить инструмент Prometheus:

`wget https://github.com/prometheus/prometheus/releases/download/v2.37.0/prometheus-2.37.0.linux-amd64.tar.gz` <br>

- Извлечь файлы:

`tar -xf prometheus-2.37.0.linux-amd64.tar.gz && mv prometheus-2.37.0.linux-amd64 /etc/prometheus` <br>

- Создать отдельную учетную запись пользователя без входа в систему для Prometheus:

`useradd prometheus --shell=/bin/false --no-create-home` <br>

- Скопировать prometheus и promtool в /usr/local/bin и изменить право собственности на исполняемые файлы и каталог /etc/prometheus пользователя Prometheus:

`sudo cp -pr /etc/prometheus/promtool prometheus /usr/local/bin/` <br>
`sudo chown prometheus:prometheus /usr/local/bin/promtool` <br>
`sudo chown prometheus:prometheus /usr/local/bin/prometheus` <br>
`sudo chown -R prometheus:prometheus /etc/prometheus` <br>

- Создать каталог локального хранилищ, а также изменить владельца на Prometheus:

`sudo mkdir /var/lib/prometheus` <br>
`sudo chown -R prometheus:prometheus /var/lib/prometheus` <br>

- Создайть служебный файл для Prometheus и добавить в него приведенное ниже содержимое:

`sudo vim /etc/systemd/system/prometheus.service` <br>

>Description=Prometheus <br>
Wants=network-online.target <br>
After=network-online.target <br>
User=prometheus <br>
Group=prometheus <br>
Type=simple <br>
ExecStart=/usr/local/bin/prometheus \ <br>
--config.file /etc/prometheus/prometheus.yml \ <br>
--storage.tsdb.path /var/lib/prometheus/ \ <br>
--web.console.templates=/etc/prometheus/consoles \ <br>
--web.console.libraries=/etc/prometheus/console_libraries <br>
WantedBy=multi-user.target

- Перезагрузить systemd и запустить службу Prometheus:

`sudo systemctl daemon-reload` <br>
`systemctl start prometheus` <br>
`systemctl status prometheus` <br>

<img src="./../../misc/images/part_7/3.jpg" alt="3" />

- Проверить работу порта:

<img src="./../../misc/images/part_7/4.jpg" alt="4" />

## Создание собственного дашборда

- Перейти на страницу Grafana http://localhost:3000 (логин и пароль - admin):

<img src="./../../misc/images/part_7/5.jpg" alt="5" />

- Перейти в раздел *Data sources* и нажать *Add data source*. В предложенном списке выбрать *Prometheus* и в настройках *URL* указать адрес *Prometheus'а* (http://localhost:9090):

<img src="./../../misc/images/part_7/6.jpg" alt="6" />

- Сохранить изменения:

<img src="./../../misc/images/part_7/7.jpg" alt="7" />

- Перейти в *Dashboards* и нажать *Create Dashboard*:

<img src="./../../misc/images/part_7/8.jpg" alt="8" />

- Добавить на dashboard Grafana отображение CPU:

<img src="./../../misc/images/part_7/9.jpg" alt="9" />

- Доступной оперативной памяти:

<img src="./../../misc/images/part_7/10.jpg" alt="10" />

- Доступного свободного места:

<img src="./../../misc/images/part_7/11.jpg" alt="11" />

- Количества операций ввода/вывода:

<img src="./../../misc/images/part_7/12.jpg" alt="12" />

- Итоговый вид дашборда:

<img src="./../../misc/images/part_7/13.jpg" alt="13" />

## Тестирование дашборда

**Запустить bash-скрипт из Части 2 и посмотреть на нагрузку жесткого диска (место на диске и операции чтения/записи)**

- Создание мусора:

<img src="./../../misc/images/part_7/14.jpg" alt="14" />

- Очистка мусора:

<img src="./../../misc/images/part_7/15.jpg" alt="15" />

- Установить утилиту stress:

`sudo apt install stress` <br>

- Запустить команду stress и посмотреть на нагрузку жесткого диска, оперативной памяти и ЦПУ:

`stress -c 2 -i 1 -m 1 --vm-bytes 32M -t 60s` <br>
<img src="./../../misc/images/part_7/16.jpg" alt="16" />