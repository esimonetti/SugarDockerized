#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

PATH_MODULES=./data/app/installable-modules

if [ -z $1 ]
then
    echo Provide the zip file path containing the Sugar module loadable package
else
    # check if the stack is running
    RUNNING=`docker ps | grep sugar-cron | wc -l`

    if [ $RUNNING -gt 0 ]
    then
        # enter the repo's root directory
        REPO="$( dirname ${BASH_SOURCE[0]} )/../../"
        cd $REPO
        # running
        # if it is our repo
        if [ -f '.gitignore' ] && [ -d 'data' ]
        then
            # locate the zip
            if [ ! -f $1 ]
            then
                echo $1 does not exist, please provide the zip file path containing the Sugar module loadable package
                exit 1
            fi

            cp ./utilities/module/installModule.php ./data/app/installModule.php
            
            if [ -d $PATH_MODULES ]
            then
                rm -rf $PATH_MODULES
            fi

            mkdir $PATH_MODULES
            cp $1 $PATH_MODULES
            INSTALLABLE_MODULE=`ls -lat $PATH_MODULES | grep '\.zip' | head -1 | awk '{print $9}'`
            PATHS=$(echo $PATH_MODULES | tr '/' '\n')
            FINAL_PATH=''
            for TMPPATH in $PATHS
            do
                FINAL_PATH=$TMPPATH
            done

            ./utilities/runcli.sh "php ../installModule.php ../$FINAL_PATH/$INSTALLABLE_MODULE"

            rm -rf $PATH_MODULES
            ./utilities/repair.sh
        else
            echo The command needs to be executed from within the clone of the repository
        fi
    else
        echo The stack needs to be running to complete the Sugar module loadable package\'s installation
    fi
fi
