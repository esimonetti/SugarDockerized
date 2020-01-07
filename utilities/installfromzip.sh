#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

if [ -z $1 ]
then
    echo Provide the zip file path containing the Sugar installer
else
    # check if the stack is running
    running=`docker ps | grep sugar-cron | wc -l`

    if [ $running -gt 0 ]
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
            
            # fix up permissions
            docker restart sugar-permissions &
            echo Fixing Sugar permissions, please wait...
            wait `jobs -p`
            echo Done

            # clear elastic data
            echo Deleting all previous Elasticsearch indices, please wait...
            for index in $(./utilities/runcli.sh "curl -f 'http://sugar-elasticsearch:9200/_cat/indices' -Ss | awk '{print \$3}'")
            do
                ./utilities/runcli.sh "curl -f -XDELETE 'http://sugar-elasticsearch:9200/$index' -Ss -o /dev/null"
            done
            echo Done

            # generate silent installer config
            ./utilities/generateinstallconfigs.sh

            # run silent installer
            echo Running installation, please wait...
            curl -f 'http://docker.local/sugar/install.php?goto=SilentInstall&cli=true' -Ss -o /dev/null
            echo  
            echo Installation completed!
            echo 
            echo You can now access the instance on your browser with http://docker.local/sugar
        else
            echo The command needs to be executed from within the clone of the repository
        fi
    else
        echo The stack needs to be running to complete Sugar\'s installation
    fi
fi
