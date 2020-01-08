#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

REPOURL=https://github.com/esimonetti/SugarDockerized.git

INSTALLDIR='sugardocker'

if [ -d $INSTALLDIR ]
then
    echo The destination directory $INSTALLDIR already exists
    echo Either proceed with an upgrade or remove the current $INSTALLDIR directory
    exit 1
fi

# check for git existence
if [ `command -v git | grep git | wc -l` -eq 0 ]
then
    echo Please install \"git\" before running the installation command
    exit 1
fi

if [ `command -v docker | grep docker | wc -l` -eq 0 ]
then
    echo Please install \"Docker\" before running the installation command
    exit 1
fi

# clone the repository
git clone $REPOURL $INSTALLDIR
cd $INSTALLDIR
#git checkout dev
rm -rf .git

# check if docker deamon is running
NOTRUNNING=`docker ps 2>&1 | grep -i "cannot connect to the docker daemon" | wc -l`
if [ $NOTRUNNING -gt 0 ]
then
    echo Docker is not running. Please make sure to start Docker
fi

echo 
echo Installation of SugarDockerized completed on $INSTALLDIR
echo Execute \"./utilities/stack.sh 90 up\" to get started with a stack, from within your directory $INSTALLDIR
echo
