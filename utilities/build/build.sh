#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

if [ -z $1 ]
then
    echo Provide as first parameter the flavour \(e.g.: pro or ent\)
    exit 1
fi

if [ -z $2 ]
then
    echo Provide as second parameter the version number \(e.g.: 9.0.1 or 9.2.0 or 9.3.0\)
    exit 1
fi

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
        # locate the Mango checkout
        if [ ! -d 'data/app/Mango' ] || [ ! -d 'data/app/Mango/sugarcrm' ] || [ ! -f 'data/app/Mango/build/rome/build.php' ]
        then
            echo Complete a full Mango checkout in ./data/app/Mango to proceed further with the build
            exit 1
        fi

        # remove current sugar dir
        if [ -d './data/app/sugar' ]
        then
            sudo rm -rf ./data/app/sugar
            mkdir ./data/app/sugar
        fi

        # remove current sugar build if exists
        if [ -d './data/app/build' ]
        then
            sudo rm -rf ./data/app/build
            mkdir ./data/app/build
        fi

        echo Updating git submodules, please wait...
        ./utilities/runcli.sh "cd ../Mango/sugarcrm && git submodule update"
        echo Done

        echo Executing composer install, please wait...
        ./utilities/runcli.sh "cd ../Mango/sugarcrm && composer install --ignore-platform-reqs"
        echo Done

        echo Executing Sugar build, please wait...
        ./utilities/runcli.sh "cd ../Mango/build/rome && php build.php --build_dir=../../../build --dir=sugarcrm --ver=$2 --flav=$1"
        echo Done

        echo Copying built files into ./data/app/sugar/, please wait...
        sudo rsync -a ./data/app/build/$1/sugarcrm/* ./data/app/sugar/
        echo Done

        echo Recreating autoload files
        ./utilities/runcli.sh "composer dumpautoload"
        echo Done

        # refresh system
        ./utilities/build/refreshsystem.sh

        # execute silent installation
        ./utilities/build/silentinstall.sh

        # for some reason during the build the config_override is wiped, so let's re-create it
        ./utilities/runcli.sh "php -f ../configs/config_override.php > ./config_override.php"
    else
        echo The command needs to be executed from within the clone of the repository
    fi
else
    echo The stack needs to be running to complete Sugar\'s build and installation
fi
