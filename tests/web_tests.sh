#!/bin/bash
echo Installing composer dependencies if any
./utilities/runcli.sh "cd ./web_tests && composer install"

echo Executing web tests
MAX=60

while ! mysqladmin ping -h 127.0.0.1 --silent; do
    echo MySQL is not ready... sleeping...
    sleep 5
    MAX=$((MAX - 5))
    if [ $MAX -le 0 ]
    then
        echo Maximum MySQL timeout reached
        exit 1
    fi
done

for i in {1..5}
do
    OUTPUT=`curl -s http://docker.local/sugar/web_tests/test_$i.php | grep ok | wc -l`
    if [ $OUTPUT != '1' ]
    then
        echo Error for script test_$i.php
        exit 1
    else
        echo Script test_$i.php executed successfully
    fi
done
