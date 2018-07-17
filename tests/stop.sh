#!/bin/bash
if [ -z ${STACK} ]
then
    echo The script needs the stack as a parameter
    exit 1
else
    echo Stopping environment ${STACK}
    docker-compose -f ${STACK} down
fi
