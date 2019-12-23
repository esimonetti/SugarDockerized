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
        # get apache ownership
        ownership=($(docker exec -it sugar-cron cat /etc/passwd | grep sugar | awk '{ split($0, out, ":"); print out[3],out[4] }'))
        echo Setting from within the sugar-cron container, the ownership of /var/www/html/sugar to ${ownership[0]}:${ownership[1]}
        docker exec -it sugar-cron sudo chown -R ${ownership[0]}:${ownership[1]} /var/www/html/sugar

        # get mysql ownership
        ownership=($(docker exec -it sugar-mysql cat /etc/passwd | grep mysql | awk '{ split($0, out, ":"); print out[3],out[4] }'))
        echo Setting from within the sugar-mysql container, the ownership of /var/lib/mysql to ${ownership[0]}:${ownership[1]}
        docker exec -it sugar-mysql chown -R ${ownership[0]}:${ownership[1]} /var/lib/mysql

        # get elastic ownership
        ownership=($(docker exec -it sugar-elasticsearch cat /etc/passwd | grep elastic | awk '{ split($0, out, ":"); print out[3],out[4] }'))
        echo Setting from within the sugar-elasticsearch container, the ownership of /usr/share/elasticsearch/data to ${ownership[0]}:${ownership[1]}
        docker exec -it sugar-elasticsearch chown -R ${ownership[0]}:${ownership[1]} /usr/share/elasticsearch/data

        # get redis ownership
        ownership=($(docker exec -it sugar-redis cat /etc/passwd | grep redis | awk '{ split($0, out, ":"); print out[3],out[4] }'))
        echo Setting from within the sugar-redis container, the ownership of /data to ${ownership[0]}:${ownership[1]}
        docker exec -it sugar-redis chown -R ${ownership[0]}:${ownership[1]} /data
    else
        echo Please start the relevant stack first
    fi
else
    if [ ! -d 'data' ]
    then
        echo \"data\" cannot be empty, the command needs to be executed from within the clone of the repository
    fi
fi
