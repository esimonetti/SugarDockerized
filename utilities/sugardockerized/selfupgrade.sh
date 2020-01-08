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

# check if rsync is installed
if [ `command -v rsync | grep rsync | wc -l` -eq 0 ]
then
    echo Please install \"rsync\" before running the upgrade command
    exit 1
fi

# if it is our repo
if [ -f '.gitignore' ] && [ -d 'data' ]
then
    # check if the stack is running
    running=`docker ps 2>&1 | grep sugar-web1 | wc -l`

    if [ $running -gt 0 ]
    then
        echo A stack is running, please take the stack down to run the update
    else
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

        if $NEEDSUPGRADE
        then
            echo SugarDockerized needs to be upgraded
            echo Upgrading
            # clone the repository
            INSTALLDIR=tmpsugardockerized
            git clone $REPOURL $INSTALLDIR
            cd $INSTALLDIR
            #git checkout dev
            rm -rf .git
            rsync -av --exclude data ./* ../
            cd ..
            rm -rf $INSTALLDIR
            echo Upgrade completed! SugarDockerized is now up to date
        else
            echo SugarDockerized is up to date
        fi
    fi
else
    if [ ! -d 'data' ]
    then
        echo \"data\" cannot be empty, the command needs to be executed from within the clone of the repository
    fi
fi
