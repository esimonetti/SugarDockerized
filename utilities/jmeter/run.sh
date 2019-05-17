#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

# enter the repo's root directory
REPO="$( dirname ${BASH_SOURCE[0]} )/../../"
cd $REPO

if [ -d 'data/jmeter/performance' ] && [ -f 'data/jmeter/performance/build.xml' ]
then
    if [ $# -eq 0 ]
    then
        echo Provide the ant command to run as arguments
    else
        user_command="$@"
        docker run -v ${PWD}/data/jmeter:/opt/jmeter --add-host docker.local:10.10.10.10 -t -i sugar-jmeter bash -c "cd /opt/jmeter/performance && $user_command"
    fi
else
    echo Please run ./utilities/jmeter/build.sh first, from within the clone of the repository
fi
