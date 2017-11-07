# Sugar Dockerized
This repository will help you deploy a Docker based development full stack for the latest Sugar version, meeting all the platform requirements.

## Current version support
The currently supported version is 7.9 with all the platform requirements listed here: http://support.sugarcrm.com/Resources/Supported_Platforms/Sugar_7.9.x_Supported_Platforms/ leveraging PHP version 7.1.

## Running the minimal stack
* Run the stack with `docker-compose up -d`
* Stop the stack with `docker-compose down`

This stack will run only one web server, for initial development

## Running the stack with load balancer
* Run the stack with `docker-compose -f lb.yml up -d`
* Stop the stack with `docker-compose -f lb.yml down`

This stack is identical to the previous. The only difference is load balancer in front of the web servers and 2 web servers, for more complete real-life testing

## System's details
* Browser url: http://localhost/sugar/
* MySQL hostname: sugar-mysql
* MySQL user: root
* MySQL password: root
* MySQL is accessible from the host on port 3306 using ip 127.0.0.1 (not localhost)
* Elasticsearch hostname: sugar-elasticsearch
* Redis hostname: sugar-redis

## Core stack components
* Linux
* Apache
* MySQL
* PHP
* Redis
* Elasticsearch

## Docker containers
* Apache load balancer (only on lb.yml)
* Two Apache web servers behind the load balancer (only on lb.yml, otherwise single Apache web server)
* Cronjob server
* MySQL database
* Elasticsearch
* Redis

## File locations
* The Sugar application files served from the web servers and leveraged by the cronjob server are located in ./data/app/sugar/. Within the web servers and the cronjob server the location is /var/www/html/sugar/
* MySQL files are located in ./data/mysql
* Elasticsearch files are located in ./data/elasticsearch
* Redis files are located in ./data/redis

## Disable Zend Opcache
If you do need to disable/enable Zend Opcache to customise the system without opcache enabled, you can:
* Edit the two config files on `./images/php/config/php/mods-available/opcache.ini` and on `./images/cron/config/php/mods-available/opcache.ini`
* Set `opcache.enable=0` and `opcache.enable_cli=0`
* `docker-compose down`
* `docker-compose up -d --build`

To re-enable, repeat by setting `opcache.enable=1` and `opcache.enable_cli=1`
