#!/bin/bash

# Rafael Fernandes
# sugarcrm.com

if [ -z $1 ]
then
    echo Provide the backup suffix as script parameters
else
    # check if the stack is running
    running=`docker ps | grep sugar-mysql | wc -l`

    if [ $running -gt 0 ]
    then
        # running
        now="$(date)"
        echo "Starting restore at $now"

        # enter the repo's root directory
        REPO="$( dirname ${BASH_SOURCE[0]} )/../"
        cd $REPO

        # locate the file
        if [ ! -f $1 ]
        then
            echo $1 does not exist, please provide the tar.gz file path containing the backup to restore
            exit 1
        fi

        # if it is our repo, and the source exists, and the destination does not
        if [ -f '.gitignore' ] && [ -d 'data' ]
        then
            echo "Cleaning up previous install (./data/app/sugar) if any, please wait..."
            if [ -d 'data/app/sugar' ]
            then
                rm -rf data/app/sugar
            fi
            TEMP_FOLDER=./data/app/tmp
            if [ -d $TEMP_FOLDER ]
            then
                rm -rf $TEMP_FOLDER
            fi

            mkdir -p "$TEMP_FOLDER/sql"
            echo Decompressing $1, please wait...
            tar -xf $1 -C $TEMP_FOLDER --strip-components=1
            for f in $TEMP_FOLDER/*.sql; do
                mv "$f" "$TEMP_FOLDER/sql/"
            done
            for f in $TEMP_FOLDER/sugar*; do
                mv "$f" $TEMP_FOLDER/sugar
            done

            if [ ! -d $TEMP_FOLDER/sugar ]
            then
                echo \"$TEMP_FOLDER/sugar\" cannot be empty
                exit 1
            fi

            if [ -d $TEMP_FOLDER/sql ]
            then
                find $TEMP_FOLDER/sql -type f -name 'sugar*' ! -name '*triggers*' -exec sh -c 'sql=${1:-:}; x="${2:-:}"; mv "$x" "$sql/sugar.sql"' bash "$TEMP_FOLDER/sql" {} +\;
                find $TEMP_FOLDER/sql -type f -name '*triggers*' -exec sh -c 'sql=${1:-:}; x="{}"; mv "${2:-:}" "$sql/sugar_triggers.sql"' bash "$TEMP_FOLDER/sql" {} +\;
            fi

            echo Restoring application files
            SUGAR_TMP_DIR=`ls -d $TEMP_FOLDER/sugar*`
            mv $SUGAR_TMP_DIR ./data/app/sugar
            echo Application files restored

            echo Restoring database
            docker exec -it sugar-mysql mysqladmin -h localhost -f -u root -proot drop sugar | grep -v "mysqladmin: \[Warning\]"
            docker exec -it sugar-mysql mysqladmin -h localhost -u root -proot create sugar | grep -v "mysqladmin: \[Warning\]"

            if [ -f $TEMP_FOLDER/sql/sugar.sql.tgz ]
            then
                if hash tar 2>/dev/null; then
                    tar -zxf $TEMP_FOLDER/sql/sugar.sql.tgz
                    echo Database uncompressed to $TEMP_FOLDER/sql/sugar.sql
                fi
            fi

            if [ -f $TEMP_FOLDER/sql/sugar.sql ]
            then
                cat $TEMP_FOLDER/sql/sugar.sql | docker exec -i sugar-mysql mysql -h localhost -u root -proot sugar
                if [ -f $TEMP_FOLDER/sql/sugar_triggers.sql ]
                then
                    cat $TEMP_FOLDER/sql/sugar_triggers.sql | docker exec -i sugar-mysql mysql -h localhost -u root -proot sugar
                fi
                echo Database restored
            else
                echo Database not found! The selected restore is corrupted
                exit 1
            fi
            echo "Dockerizing Backup config files..."
            sed -i.bak 's@RewriteBase /@RewriteBase /sugar@g' ./data/app/sugar/.htaccess
            cat ./utilities/configs/config_override_dockerized.php >> ./data/app/sugar/config_override.php
            
            echo "Cleaning up please wait..."
            if [ -d $TEMP_FOLDER ]
            then
                rm -rf $TEMP_FOLDER
            fi

            # refresh all transient storages
            ./utilities/build/refreshsystem.sh

            echo Repairing system
            cp ./utilities/build/simpleRepair.php ./data/app/sugar
            ./utilities/runcli.sh "php simpleRepair.php"
            echo System repaired

            echo Performing Elasticsearch re-index
            ./utilities/runcli.sh "./bin/sugarcrm search:silent_reindex --clearData"
            echo Restore completed!
        fi
        now="$(date)"
        echo "Restore finished at $now"
    else
        echo The stack is not running, please start the stack first
    fi
fi
