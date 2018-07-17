#!/bin/bash
echo Installing composer dependencies if any
./utilities/runcli.sh "cd ./web_tests && composer install"

echo Executing web tests
MAX=120
INTERVAL=5
MAX_MYSQL=$MAX
MAX_ELASTIC=600

while [ `./utilities/runcli.sh "(echo >/dev/tcp/sugar-mysql/3306) &>/dev/null && echo 1 || echo 0"` != "1" ] ; do
    echo MySQL is not ready... sleeping...
    sleep $INTERVAL
    MAX_MYSQL=$((MAX_MYSQL - $INTERVAL))
    if [ $MAX_MYSQL -le 0 ]
    then
        echo Maximum MySQL timeout reached
        exit 1
    fi
done

while [ `./utilities/runcli.sh "(echo >/dev/tcp/sugar-elasticsearch/9200) &>/dev/null && echo 1 || echo 0"` != "1" ] ; do
    echo Elasticsearch is not ready... sleeping...
    sleep $INTERVAL
    docker ps
    docker logs sugar-elasticsearch
    MAX_ELASTIC=$((MAX_ELASTIC - $INTERVAL))
    if [ $MAX_ELASTIC -le 0 ]
    then
        echo Maximum Elasticsearch timeout reached
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
