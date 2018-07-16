#!/bin/bash
if [ -z $1 ]
then
    echo The script needs the stack as a parameter
else
    echo Starting environment $1
    docker-compose -f $1 up -d --build
fi
