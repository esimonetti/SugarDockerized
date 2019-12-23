#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

# enter the repo's root directory
REPO="$( dirname ${BASH_SOURCE[0]} )/../"
cd $REPO

# if it is our repo, and the source exists, and the destination does not
if [ -f '.gitignore' ] && [ -d 'data' ]
then
    # check if the stack is running
    running=`docker ps | grep sugar-web1 | wc -l`

    if [ $running -gt 0 ]
    then
        echo Please stop any running stack before setting permissions

        # get apache ownership
        #ownership=($(docker exec -it sugar-cron cat /etc/passwd | grep sugar | awk '{ split($0, out, ":"); print out[3],out[4] }'))
        #echo Setting from within the sugar-cron container, the ownership of /var/www/html/sugar to sugar:sugar \(${ownership[0]}:${ownership[1]}\)
        #docker exec -it sugar-cron sudo chown -R ${ownership[0]}:${ownership[1]} /var/www/html/sugar

        # get mysql ownership
        #ownership=($(docker exec -it sugar-mysql cat /etc/passwd | grep mysql | awk '{ split($0, out, ":"); print out[3],out[4] }'))
        #echo Setting from within the sugar-mysql container, the ownership of /var/lib/mysql to mysql:mysql \(${ownership[0]}:${ownership[1]}\)
        #docker exec -it sugar-mysql chown -R ${ownership[0]}:${ownership[1]} /var/lib/mysql

        # get elastic ownership (group is root)
        #ownership=($(docker exec -it sugar-elasticsearch cat /etc/passwd | grep elasticsearch | awk '{ split($0, out, ":"); print out[3],out[4] }'))
        #echo Setting from within the sugar-elasticsearch container, the ownership of /usr/share/elasticsearch/data to elasticsearch:root \(${ownership[0]}:0\)
        #docker exec -it sugar-elasticsearch sudo chown -R ${ownership[0]}:0 /usr/share/elasticsearch/data

        # get redis ownership
        #ownership=($(docker exec -it sugar-redis cat /etc/passwd | grep redis | awk '{ split($0, out, ":"); print out[3],out[4] }'))
        #echo Setting from within the sugar-redis container, the ownership of /data to redis:redis \(${ownership[0]}:${ownership[1]}\)
        #docker exec -it sugar-redis chown -R ${ownership[0]}:${ownership[1]} /data

        # logs should look like this
        #Setting from within the sugar-cron container, the ownership of /var/www/html/sugar to sugar:sugar (1000:1000)
        #Setting from within the sugar-mysql container, the ownership of /var/lib/mysql to mysql:mysql (999:999)
        #Setting from within the sugar-elasticsearch container, the ownership of /usr/share/elasticsearch/data to elasticsearch:root (101:0)
        #Setting from within the sugar-redis container, the ownership of /data to redis:redis (999:999)
    else
        echo Setting ownership of the data directory to $(whoami):$(groups | awk '{ print $1 }') \($(id -u `whoami`):$(id -g `whoami`)\)
        sudo chown -R $(id -u `whoami`):$(id -g `whoami`) data/*
    fi
else
    if [ ! -d 'data' ]
    then
        echo \"data\" cannot be empty, the command needs to be executed from within the clone of the repository
    fi
fi
