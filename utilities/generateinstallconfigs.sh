#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

# enter the repo's root directory
REPO="$( dirname ${BASH_SOURCE[0]} )/../"
cd $REPO
if [ -f '.gitignore' ] && [ -d 'data' ]
then
    # copy the source config files under the app directory
    cp ./utilities/configs/install_config.php ./data/app/
    cp ./utilities/configs/install_config_override.php ./data/app/
    
    # copy the custom template only if it does not already exist
    if [ ! -f './data/app/custom_install_config_override.php' ]
    then
        cp ./utilities/configs/custom_install_config_override.php ./data/app/
    fi

    # generate the silent installer config
    if [ -d './data/app/sugar' ]
    then
        ./utilities/runcli.sh "php ../install_config.php > ./config_si.php"
        echo The silent installer configuration has been deployed into the sugar instance
        ./utilities/runcli.sh "php ../install_config_override.php > ./config_override.php"
        echo The config override configuration has been deployed into the sugar instance
    else
        echo The sugar directory ./data/app/sugar does not exist. Please make sure all the Sugar files have been extracted on that location
    fi
else
    echo The command needs to be executed from within the clone of the repository
fi
