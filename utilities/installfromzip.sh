#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

if [ -z $1 ]
then
    echo Provide the zip file path containing the Sugar installer
else
    # check if the stack is running
    RUNNING=`docker ps | grep sugar-cron | wc -l`

    if [ $RUNNING -gt 0 ]
    then
        # enter the repo's root directory
        REPO="$( dirname ${BASH_SOURCE[0]} )/../"
        cd $REPO
        # running
        # if it is our repo
        if [ -f '.gitignore' ] && [ -d 'data' ]
        then
            # locate the zip
            if [ ! -f $1 ]
            then
                echo $1 does not exist, please provide the zip file path containing the Sugar installer
                exit 1
            fi

            echo "Cleaning up previous install (./data/app/sugar) if any, please wait..."
            # remove current sugar dir
            if [ -d './data/app/sugar' ]
            then
                sudo rm -rf ./data/app/sugar
            fi

            # unzip the zip
            if [ -d './data/app/tmp' ]
            then
                sudo rm -rf ./data/app/tmp
            fi

            mkdir ./data/app/tmp
            echo Unzipping $1, please wait...
            unzip -q $1 -d ./data/app/tmp
            SUGAR_TMP_DIR=`ls -d ./data/app/tmp/*`
            mv $SUGAR_TMP_DIR ./data/app/sugar
            rm -rf ./data/app/tmp
            echo Done

            # refresh system
            ./utilities/build/refreshsystem.sh

            # execute silent installation
            ./utilities/build/silentinstall.sh
        else
            echo The command needs to be executed from within the clone of the repository
        fi
    else
        echo The stack needs to be running to complete Sugar\'s installation
    fi
fi
