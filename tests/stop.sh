#!/bin/bash
if [ -z $1 ]
then
    echo The script needs the stack as a parameter
    exit 1
else
    echo Stopping environment $1
    docker-compose -f $1 down
fi
