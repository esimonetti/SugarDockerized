#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

# initialise toothpaste additional args
if [ $# -eq 0 ]
then
    ARGS=""
else
    ARGS=" $@"
fi

# check if the stack is running
running=`docker ps | grep sugar-cron | wc -l`

if [ $running -gt 0 ]
then
    # enter the repo's root directory
    REPO="$( dirname ${BASH_SOURCE[0]} )/../"
    cd $REPO
    # running
    # if it is our repo
    if [ -f '.gitignore' ] && [ -d 'data' ] && [ -f 'data/app/repair.php' ]
    then
        echo Executing Repair on SugarDockerized...
        if ! [[ $ARGS =~ ^(.*)(\-\-instance)(.*)$ ]]
        then
            echo Reminder: the --instance parameter on SugarDockerized should be \"--instance ../sugar\"
        fi
        echo

        COMMAND="cd ../ && php repair.php$ARGS"
        ./utilities/runcli.sh $COMMAND
    else
        echo The command needs to be executed from within the clone of the repository
    fi
else
    echo The stack needs to be running before executing repair
fi
