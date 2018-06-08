#!/bin/bash

if [ $# -eq 0 ]
then
    echo Provide the command\(s\) to run as arguments
else
    # check if the stack is running
    running=`docker ps | grep sugar-cron | wc -l`

    if [ $running -gt 0 ]
    then
        # running
        # if it is our repo
        if [ -f '.gitignore' ] && [ -d 'data' ]
        then
            user_command="cd /var/www/html/sugar && $@"
            docker exec sugar-cron bash -c "$user_command"
        else
            echo The command needs to be executed from within the clone of the repository
        fi
    else
        echo The stack needs to be running before executing a cli command
    fi
fi
