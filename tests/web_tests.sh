#!/bin/bash
sleep 1
echo Executing web tests

while ! mysqladmin ping -h 127.0.0.1 --silent; do
    echo MySQL is not ready... sleeping...
    sleep 1
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
