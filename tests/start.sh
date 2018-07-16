#!/bin/bash
if [ -z ${STACK} ]
then
    echo The script needs the stack as a parameter
    exit 1
else
    echo Starting environment ${STACK}
    docker-compose -f ${STACK} up -d --build
fi
