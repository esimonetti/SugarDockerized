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
    if [ -f '.gitignore' ] && [ -d 'data' ]
    then
        echo Executing Toothpaste on SugarDockerized...
        if ! [[ $ARGS =~ ^(.*)(\-\-instance)(.*)$ ]]
        then
            echo Reminder: the --instance parameter for Toothpaste on SugarDockerized should be \"--instance ../sugar\"
        fi
        echo

        # run installation if needed
        ./utilities/toothpaste/install.sh minimal

        TOOTHPASTE_COMMAND="cd ../toothpaste && ./vendor/bin/toothpaste$ARGS"
        ./utilities/runcli.sh $TOOTHPASTE_COMMAND
    else
        echo The command needs to be executed from within the clone of the repository
    fi
else
    echo The stack needs to be running before executing Toothpaste
fi
