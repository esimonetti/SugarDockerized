#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

if [ -z $1 ]
then
    echo Provide the backup suffix as script parameters
else
    # check if the stack is running
    running=`docker ps | grep sugar-web1 | wc -l`

    if [ $running -gt 0 ]
    then
        # running

        # enter the repo's root directory
        REPO="$( dirname ${BASH_SOURCE[0]} )/../"
        cd $REPO

        BACKUP_DIR="backups/backup_$1"
        echo Restoring sugar from \"$BACKUP_DIR\"

        # if it is our repo, and the source exists, and the destination does not
        if [ -f '.gitignore' ] && [ -d 'data' ] && [ -d $BACKUP_DIR ] && [ -d $BACKUP_DIR/sugar ] && [ -f $BACKUP_DIR/sugar.sql ]
        then
            if [ -d 'data/app/sugar' ]
            then
                rm -rf data/app/sugar
            fi
            sudo rsync -a $BACKUP_DIR/sugar data/app/
            docker start sugar-permissions
            echo Application files restored
            mysqladmin -h docker.local -f -u root -proot drop sugar
            mysqladmin -h docker.local -u root -proot create sugar
            mysql -h docker.local -u root -proot sugar < $BACKUP_DIR/sugar.sql
            echo Database restored
            ./utilities/runcli.sh php ../repair.php --instance .
            echo System repaired
        else
            if [ ! -d 'data' ]
            then
                echo \"data\" cannot be empty, the command needs to be executed from within the clone of the repository
            fi

            if [ ! -d $BACKUP_DIR/sugar ]
            then
                echo \"$BACKUP_DIR/sugar\" cannot be empty
            fi

            if [ ! -f $BACKUP_DIR/sugar.sql ]
            then
                echo \"$BACKUP_DIR/sugar.sql\" does not exist
            fi

            if [ ! -d $BACKUP_DIR ]
            then
                echo $BACKUP_DIR does not exist
            fi
        fi

    else
        echo The stack is not running, please start the stack first
    fi
fi
