#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

if [ -z $1 ] || [ -z $2 ]
then
    echo Provide the source data directory and the destination data directory as script parameters
else
    # check if the stack is running
    running=`docker ps | grep sugar-web1 | wc -l`

    if [ $running -gt 0 ]
    then
        # running
        echo The stack is running, please stop the stack first
    else
        # enter the repo's root directory
        REPO="$( dirname ${BASH_SOURCE[0]} )/../"
        cd $REPO

        # not running
        echo Copying \"$1\" to \"$2\"

        # if it is our repo, and the source exists, and the destination does not
        if [ -f '.gitignore' ] && [ -d 'data' ] && [ $2 != 'data' ] && [ ! -d $2 ]  && [ -d $1 ]
        then
            echo Copying $1 to $2
            sudo rsync -a $1/* $2
            echo Copy completed, you can now swap or start the system
        else
            #echo The repository seems to have a problem

            if [ $2 == 'data' ]
            then    
                echo The destination directory cannot be data!
            fi
        
            if [ ! -d 'data' ]
            then
                echo \"data\" cannot be empty, the command needs to be executed from within the clone of the repository
            fi

            if [ ! -d $1 ]
            then
                echo $1 does not exist
            else
                if [ -d $2 ]
                then
                    echo $2 exists already
                fi
            fi
        fi
    fi
fi
