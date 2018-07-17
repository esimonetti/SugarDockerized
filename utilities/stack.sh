#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

if [ -z $1 ] || [ -z $2 ]
then
    echo Provide two parameters. The sugar version to run the default stack for \(eg: 81, 80, 710, 79, 77\) and the action \(up, down\)
else
    # enter the repo's root directory
    REPO="$( dirname ${BASH_SOURCE[0]} )/../"
    cd $REPO

    # include stack configuration
    . ./utilities/stacks.conf

    # if it is our repo, and the source exists, and the destination does not
    if [ -f '.gitignore' ] && [ -d 'data' ] && [ ! -z ${stacks[$1]} ] && [ -f ${stacks[$1]} ]
    then

        # check if the stack is running
        running=`docker ps | grep sugar-web1 | wc -l`

        if [ $running -gt 0 ] && [ $2 == 'up' ]
        then
            echo A stack is running, please take the stack down first
        else

            echo ${stacks[$1]} $2

            if [ $2 == 'down' ]
            then
                if [ $running -eq 0 ]
                then
                    echo The stack is already down, skipping
                else
                    docker-compose -f ${stacks[$1]} down
                    docker-compose -f ${stacks[$1]} rm
                fi
            else
                if [ $2 == 'up' ]
                then
                    docker-compose -f ${stacks[$1]} up -d --build
                else
                    echo The action $2 is not applicable
                fi
            fi
        fi
    else
        if [ ! -d 'data' ]
        then
            echo \"data\" cannot be empty, the command needs to be executed from within the clone of the repository
        fi

        if [ -z ${stacks[$1]} ] || [ ! -f ${stacks[$1]} ]
        then
            echo A default stack for $1 does not exist
        fi
    fi
fi
