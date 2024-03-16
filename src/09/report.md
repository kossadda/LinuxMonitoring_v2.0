# Part 9. Дополнительно. Свой node_exporter

**Написать bash-скрипт или программу на Си, которая собирает информацию по базовым метрикам системы (ЦПУ, оперативная память, жесткий диск (объем)). Скрипт или программа должна формировать html страничку по формату Prometheus, которую будет отдавать nginx.** <br>
**Саму страничку обновлять можно как внутри bash-скрипта или программы (в цикле), так и при помощи утилиты cron, но не чаще, чем раз в 3 секунды.**

## Установка nginx

`sudo apt install nginx`

- Перезагрузить systemd и запустить службу Node Exporter:

`sudo systemctl daemon-reload` <br>
`sudo systemctl start nginx` <br>
`sudo systemctl status nginx` <br>

<img src="./../../misc/images/part_9/1.jpg" alt="1" />

## Настройка конфигураций

- Создать файл **prometheus.yml** и помимо основных портов (9090 для *Prometheus* и 9100 для *Node Exporter*) создать еще одну рабочую цель под названием *my_node*, работающую на порте 8080:

`sudo vim prometheus.yml` <br>
<img src="../../misc/images/part_9/2.jpg" alt="2" />

- Копировать **prometheus.yml** в системную директорию:

`sudo cp prometheus.yml /etc/prometheus/` <br>

- Создать файл **nginx.conf**, указать рабочую директорию с будущим html файлом, настроить на прослушивание порта 8080:

`sudo vim nginx.conf` <br>
<img src="../../misc/images/part_9/3.jpg" alt="3" />

- Копировать **nginx.conf** в системную директорию:

`sudo cp nginx.conf /etc/nginx.conf/` <br>

- Перезапустить службы prometheus.service и nginx.service после внесенных изменений:

`systemctl restart nginx.service` <br>
`systemctl restart prometheus.service` <br>

- Создать скрипт собирающий необходимые данные (из **Части 7**) в **index.html** с обновлением данных в 3 секунды:

<img src="../../misc/images/part_9/4.jpg" alt="4" />

- После запуска скрипта данные из index.html должны появиться на http://localhost:8080/metrics/:

`curl localhost:8080/metrics/` <br>
<img src="../../misc/images/part_9/5.jpg" alt="5" />

- Если данные успешно считались и prometheus получил сигнал с указанного порта, то в графе **State** у *my_node* будет указано состояние **UP**:

<img src="../../misc/images/part_9/6.jpg" alt="6" />

## Создание дашборда

- Устанавливаем панель с метрикой для RAM:

<img src="../../misc/images/part_9/7.jpg" alt="7" />

- Метрикой для CPU:

<img src="../../misc/images/part_9/8.jpg" alt="8" />

- Метрикой для свободной памяти:

<img src="../../misc/images/part_9/9.jpg" alt="9" />

- Вид готового дашборда:

<img src="../../misc/images/part_9/10.jpg" alt="10" />

## Проведение тестов из Части 7

- Создание мусора:

<img src="../../misc/images/part_9/11.jpg" alt="11" />

- Очистка мусора:

<img src="../../misc/images/part_9/12.jpg" alt="12" />

- Запустить команду stress и посмотреть на нагрузку жесткого диска, оперативной памяти и ЦПУ:

`stress -c 2 -i 1 -m 1 --vm-bytes 32M -t 100s` <br>
<img src="../../misc/images/part_9/13.jpg" alt="13" />
