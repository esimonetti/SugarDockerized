#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

# enter the repo's root directory
REPO="$( dirname ${BASH_SOURCE[0]} )/../../"
cd $REPO

VERSIONFILE=version
#VERSIONFILEURL=https://raw.githubusercontent.com/esimonetti/SugarDockerized/dev/version
VERSIONFILEURL=https://raw.githubusercontent.com/esimonetti/SugarDockerized/master/version
REPOURL=https://github.com/esimonetti/SugarDockerized.git

# if it is our repo
if [ -f '.gitignore' ] && [ -d 'data' ]
then
    NEEDSUPGRADE=false
    REPOVERSION=`curl -Ss $VERSIONFILEURL`

    if [ ! -f $VERSIONFILE ]
    then
        echo The current version is unknown
        NEEDSUPGRADE=true
    else
        CURRENTVERSION=`cat $VERSIONFILE`
        if [ $REPOVERSION != $CURRENTVERSION ]
        then
            NEEDSUPGRADE=true
        fi
    fi

    echo $NEEDSUPGRADE
fi
