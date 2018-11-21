#!/bin/bash
if [ -z $3 ]
then
    echo PHP version not provided
else
    echo Installing composer dependencies if any
    ./utilities/runcli.sh "cd ./web_tests/$3/ && composer install"

    echo Confirming that MySQL and Elasticsearch are available

    MAX=120
    INTERVAL=5
    MAX_MYSQL=$MAX
    MAX_ELASTIC=$MAX

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
        MAX_ELASTIC=$((MAX_ELASTIC - $INTERVAL))
        if [ $MAX_ELASTIC -le 0 ]
        then
            echo Maximum Elasticsearch timeout reached
            exit 1
        fi
    done

    echo Executing CLI and web tests

    for i in {1..5}
    do
        OUTPUT_CLI=`./utilities/runcli.sh "php ./web_tests/$3/test_$i.php | grep ok | wc -l"`
        if [ $OUTPUT_CLI != '1' ]
        then
            echo Error for CLI script test_$i.php
            echo Completing a syntax check for script ./web_tests/$3/test_$i.php
            echo `./utilities/runcli.sh "php -l ./web_tests/$3/test_$i.php"`
            echo Retrieving complete logs from the Cron CLI server:
            docker logs sugar-cron
            exit 1
        else
            echo Script ./web_tests/$3/test_$i.php executed successfully via CLI
        fi

        OUTPUT_WEB=`curl -s http://docker.local/sugar/web_tests/$3/test_$i.php | grep ok | wc -l`
        if [ $OUTPUT_WEB != '1' ]
        then
            echo Error for web script test_$i.php
            echo Retrieving complete logs from the web server:
            docker logs sugar-web1
            exit 1
        else
            echo Script http://docker.local/sugar/web_tests/$3/test_$i.php executed successfully via web
        fi
    done
fi
