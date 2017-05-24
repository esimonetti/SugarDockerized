# Sugar 7.9 Dockerized
This repository will help you deploy a Docker based development full stack for Sugar 7.9 meeting all the platform requirements listed here: http://support.sugarcrm.com/Resources/Supported_Platforms/Sugar_7.9.x_Supported_Platforms/

## Running the stack
* Run the stack with `docker-compose up -d`
* Stop the stack with `docker-compose down`

## System's details
* Browser url: http://localhost/sugar/
* MySQL hostname: sugar78-mysql
* MySQL user: root
* MySQL password: root
* MySQL is accessible from the host on port 3306 using ip 127.0.0.1 (not localhost)
* Elasticsearch hostname: sugar78-elasticsearch
* Redis hostname: sugar78-redis

## Core stack components
* Linux
* Apache
* MySQL
* PHP
* Redis
* Elasticsearch

## Docker containers
* Apache load balancer
* Two Apache web servers behind the load balancer
* Cronjob server
* MySQL database
* Elasticsearch
* Redis

## File locations
* The Sugar application files served from the web servers and leveraged by the cronjob server are located in ./data/app/sugar/. Within the web servers and the cronjob server the location is /var/www/html/sugar/
* MySQL files are located in ./data/mysql
* Elasticsearch files are located in ./data/elasticsearch
* Redis files are located in ./data/redis

# Disable Zend Opcache
If you do need to disable/enable Zend Opcache to customise the system without opcache enabled, you can:
* Edit the two config files on `./images/php65/config/php5/mods-available/opcache.ini` and on `./images/cron/config/php5/mods-available/opcache.ini`
* Set `opcache.enable=0` and `opcache.enable_cli=0`
* `docker-compose down`
* `docker-compose up -d --build`

To re-enable, repeat by setting `opcache.enable=1` and `opcache.enable_cli=1`
