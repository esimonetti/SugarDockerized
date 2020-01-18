#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

# enter the repo's root directory
REPO="$( dirname ${BASH_SOURCE[0]} )/../../"
cd $REPO

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
    RUNNING=`docker ps 2>&1 | grep sugar-web1 | wc -l`

    if [ $RUNNING -gt 0 ]
    then
        echo A stack is running, please take the stack down to run the update
    else
        NEEDSUPGRADE=`./utilities/sugardockerized/checkversion.sh`

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
            # forcefully align utilities dir
            rsync -av --delete ./utilities/* ../utilities/
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
