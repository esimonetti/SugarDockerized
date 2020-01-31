#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

# check if the stack is running
RUNNING=`docker ps | grep sugar-cron | wc -l`

if [ $RUNNING -gt 0 ]
then
    # enter the repo's root directory
    REPO="$( dirname ${BASH_SOURCE[0]} )/../../"
    cd $REPO
    # running
    # if it is our repo
    if [ -f '.gitignore' ] && [ -d 'data/app/sugar' ]
    then
        # fix up permissions
        echo Fixing Sugar permissions, please wait...
        docker restart sugar-permissions > /dev/null
        while [ `docker ps | grep sugar-permissions | wc -l` -ne 0 ]; do
            sleep 1
        done 
        echo Done

        # restart sugar-web1
        echo Restarting sugar-web1 container, please wait...
        docker restart sugar-web1 > /dev/null
        echo Done

        if [ `docker ps | grep sugar-web2 | wc -l` -eq 1 ]
        then
            echo Restarting sugar-web2 container, please wait...
            docker restart sugar-web2 > /dev/null
            echo Done
        fi

        # restart sugar-cron
        echo Restarting sugar-cron container, please wait...
        docker restart sugar-cron > /dev/null
        echo Done

        echo Deleting all previous redis values
        docker exec -it sugar-redis redis-cli flushall > /dev/null
        echo Done

        # clear elastic data
        echo Deleting all previous Elasticsearch indices, please wait...
        for index in $(./utilities/runcli.sh "curl -f 'http://sugar-elasticsearch:9200/_cat/indices' -Ss | awk '{print \$3}'")
        do
            ./utilities/runcli.sh "curl -f -XDELETE 'http://sugar-elasticsearch:9200/$index' -Ss -o /dev/null"
        done
        echo Done
    else
        echo The command needs to be executed from within the clone of the repository
    fi
else
    echo The stack needs to be running to initialise the transient storages 
fi
