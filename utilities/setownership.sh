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
        sudo chown -R 1000:1000 data
        echo All directories and files within \"data\" are now owned by uid:gid 1000:1000
    fi
else
    if [ ! -d 'data' ]
    then
        echo \"data\" cannot be empty, the command needs to be executed from within the clone of the repository
    fi
fi
