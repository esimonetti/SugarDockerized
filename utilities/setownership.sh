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

    if [ $running -gt 0 ] && [ "$2" == 'up' ]
    then
        echo A stack is running, please take the stack down first
    else
        sudo chown -R 1000:1000 data/app
        echo All directories and files within \"data/app\" are now owned by uid:gid 1000:1000
        sudo chown -R 102:102 data/elasticsearch
        echo All directories and files within \"data/elasticsearch\" are now owned by uid:gid 102:102
        sudo chown -R 1000:1000 data/elasticsearch/62
        echo All directories and files within \"data/elasticsearch/62\" are now owned by uid:gid 1000:1000
        sudo chown -R 999:999 data/mysql
        echo All directories and files within \"data/mysql\" are now owned by uid:gid 999:999
        sudo chown -R 999:999 data/redis
        echo All directories and files within \"data/redis\" are now owned by uid:gid 999:999
    fi
else
    if [ ! -d 'data' ]
    then
        echo \"data\" cannot be empty, the command needs to be executed from within the clone of the repository
    fi
fi
