#!/bin/bash
if [ -z $1 ]
then
    echo The script needs the stack as a parameter
    exit 1
else
    echo Starting environment $1
    chown -R 1000:1000 data/app/elasticsearch
    docker-compose -f $1 up -d --build
fi
