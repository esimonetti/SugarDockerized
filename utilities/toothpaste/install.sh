#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

# enter the repo's root directory
REPO="$( dirname ${BASH_SOURCE[0]} )/../../"
cd $REPO

# if it is our repo
if [ -f '.gitignore' ] && [ -d 'data' ]
then
    if [ -d 'data/app/toothpaste' ] && [ -f 'data/app/toothpaste/composer.json' ]
    then
        # don't update if this is the minimal install
        if [ -z $1 ]
        then
            echo 
            echo Toothpaste is already installed, attempting update
            echo
            ./utilities/runcli.sh "cd ../toothpaste && composer update"
            echo Toothpaste is up to date
        fi
    else
        echo 
        echo Installing Toothpaste, please wait...
        echo
        if [ ! -d 'data/app/toothpaste' ]
        then
            ./utilities/runcli.sh "mkdir ../toothpaste"
        fi

        ./utilities/runcli.sh "cd ../toothpaste \
            && composer require esimonetti/toothpaste dev-master"

        # don't show messages if this is the minimal install
        if [ -z $1 ]
        then
            echo
            echo Installation completed
            echo
            echo Run: ./utilities/toothpaste.sh list
        fi
    fi
else
    echo The command needs to be executed from within the clone of the repository
fi
