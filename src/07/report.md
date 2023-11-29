# Part 7. Prometheus и Grafana

**Установить и настроить Prometheus и Grafana на виртуальную машину**

## Установка Grafana

- Импортировать ключ GPG репозитория Grafana, выполнив следующую команду:

`sudo vim /etc/yum.repos.d/grafana.repo` <br>

>[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt

- После добавления репозитория можно установить Grafana:

`sudo dnf update` <br>
`sudo dnf install grafana` <br>

- После установки Grafana необходимо запустить службу Grafana для доступа к веб-интерфейсу:

`sudo systemctl enable grafana-server` <br>
`sudo systemctl start grafana-server` <br>

- Открыть порт в брандмауэре, чтобы получить доступ к Grafana с другого устройства:

`sudo firewall-cmd --add-port=3000/tcp --permanent` <br>
`sudo firewall-cmd --reload` <br>

## Установка Prometheus

- Загрузить инструмент Prometheus:

`wget https://github.com/prometheus/prometheus/releases/download/v2.37.0/prometheus-2.37.0.linux-amd64.tar.gz` <br>

- Извлечь файлы:

`tar -xf prometheus-2.37.0.linux-amd64.tar.gz && mv prometheus-2.37.0.linux-amd64 /etc/prometheus` <br>

- Создать отдельную учетную запись пользователя без входа в систему для Prometheus.

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

>Description=Prometheus
Wants=network-online.target
After=network-online.target
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
--config.file /etc/prometheus/prometheus.yml \
--storage.tsdb.path /var/lib/prometheus/ \
--web.console.templates=/etc/prometheus/consoles \
--web.console.libraries=/etc/prometheus/console_libraries
WantedBy=multi-user.target

- Перезагрузить systemd и запустить службу Prometheus:

`sudo systemctl daemon-reload` <br>
`systemctl start prometheus` <br>
`systemctl enable prometheus` <br>

## Создание собственного dashboard'а

- Перейти на страницу Grafana http://localhost:3000:

<img src="../../misc/images/part_7/1.jpg" alt="1" />

- Перейти в раздел *Data sources* и нажать *Add data source*:

<img src="../../misc/images/part_7/2.jpg" alt="2" />

- В предложенном списке выбрать *Prometheus*:

<img src="../../misc/images/part_7/3.jpg" alt="3" />

- В настройка *URL* указать адрес *Prometheus'а* (http://localhost:9090):

<img src="../../misc/images/part_7/4.jpg" alt="4" />

- Сохранить изменения:

<img src="../../misc/images/part_7/5.jpg" alt="5" />

- Перейти в *Dashboard* и нажать *Add a new panel*:

<img src="../../misc/images/part_7/6.jpg" alt="6" />

- Добавить на dashboard Grafana отображение ЦПУ, доступной оперативной памяти, свободное место и кол-во операций ввода/вывода на жестком диске:

<img src="../../misc/images/part_7/7.jpg" alt="7" />

- Запустить bash-скрипт из **Части 2** и посмотреть на нагрузку жесткого диска (место на диске и операции чтения/записи):

<img src="../../misc/images/part_7/8.jpg" alt="8" />
<img src="../../misc/images/part_7/9.jpg" alt="9" />

- Установить утилиту stress:

`sudo dnf install stress` <br>

- Запустить команду stress и посмотреть на нагрузку жесткого диска, оперативной памяти и ЦПУ:

`stress -c 2 -i 1 -m 1 --vm-bytes 32M -t 60s`
<img src="../../misc/images/part_7/10.jpg" alt="10" />