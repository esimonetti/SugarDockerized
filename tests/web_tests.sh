#!/bin/bash
echo Executing web tests

MAX=60

while ! mysqladmin ping -h 127.0.0.1 --silent; do
    echo MySQL is not ready... sleeping...
    sleep 2
    MAX=$MAX - 2
    if [ $MAX -le 0 ]
    then
        echo Maximum MySQL timeout reached
        exit 1
    fi
done

for i in {1..4}
do
    OUTPUT=`curl -s http://docker.local/sugar/$i.php | grep ok | wc -l`
    if [ $OUTPUT != '1' ]
    then
        echo Error for script $i.php
        exit 1
    else
        echo Script $i.php executed successfully
    fi
done
