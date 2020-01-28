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

            FILESYNC=false
            if [ `docker ps | grep sugar-filesync | wc -l` -eq 1 ]
            then
                FILESYNC=true
                echo Stopping sugar-filesync container, please wait...
                docker stop -t 15 sugar-filesync > /dev/null
                echo Done
            fi

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

            if $FILESYNC
            then
                echo Restarting sugar-filesync container, please wait...
                docker restart sugar-filesync > /dev/null
                echo Done
            fi

            # refresh system
            ./utilities/refreshsystem.sh

            # generate silent installer config
            ./utilities/generateinstallconfigs.sh

            # run silent installer
            echo Running installation, please wait...
            curl -f 'http://docker.local/sugar/install.php?goto=SilentInstall&cli=true' -Ss -o /dev/null
            echo  
            echo Installation completed!
            echo 
            echo You can now access the instance on your browser with http://docker.local/sugar

            # post installation initialisation for specific actions (eg: creating test users etc)
            if [ -f './data/app/initsystem.php' ]
            then
                echo Executing script ./data/app/initsystem.php
                ./utilities/runcli.sh "php -f ../initsystem.php"
                echo Done
            fi
        else
            echo The command needs to be executed from within the clone of the repository
        fi
    else
        echo The stack needs to be running to complete Sugar\'s installation
    fi
fi
