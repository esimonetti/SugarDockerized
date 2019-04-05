#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

if [ -z $1 ]
then
    echo Provide the backup suffix as script parameters
else
    # check if the stack is running
    running=`docker ps | grep sugar-mysql | wc -l`

    # check if rsync is installed
    if [ `command -v rsync | grep rsync | wc -l` -eq 0 ]
    then
        echo Please install \"rsync\" before running the restore command
        exit 1
    fi

    if [ $running -gt 0 ]
    then
        # running

        # enter the repo's root directory
        REPO="$( dirname ${BASH_SOURCE[0]} )/../"
        cd $REPO

        BACKUP_DIR="backups/backup_$1"
        echo Restoring sugar from \"$BACKUP_DIR\"

        # if it is our repo, and the source exists, and the destination does not
        if [ -f '.gitignore' ] && [ -d 'data' ] && [ -d $BACKUP_DIR ] && [ -d $BACKUP_DIR/sugar ] && ( [ -f $BACKUP_DIR/sugar.sql ] || [ -f $BACKUP_DIR/sugar.sql.tgz ] )
        then
            if [ -d 'data/app/sugar' ]
            then
                rm -rf data/app/sugar
            fi
            echo Restoring application files
            sudo rsync -a $BACKUP_DIR/sugar data/app/
            echo Application files restored
            echo Fixing permissions
            docker start sugar-permissions
            echo Permissions fixed
            echo Restoring database
            docker exec -it sugar-mysql mysqladmin -h localhost -f -u root -proot drop sugar | grep -v "mysqladmin: \[Warning\]"
            docker exec -it sugar-mysql mysqladmin -h localhost -u root -proot create sugar | grep -v "mysqladmin: \[Warning\]"

            if [ -f $BACKUP_DIR/sugar.sql.tgz ]
            then
                if hash tar 2>/dev/null; then
                    tar -zxf $BACKUP_DIR/sugar.sql.tgz
                    echo Database uncompressed to $BACKUP_DIR/sugar.sql
                fi
            fi

            if [ -f $BACKUP_DIR/sugar.sql ]
            then
                cat $BACKUP_DIR/sugar.sql | docker exec -i sugar-mysql mysql -h localhost -u root -proot sugar
                echo Database restored
            else
                echo Database not found! The selected restore is corrupted
                exit 1
            fi

            if [ -f $BACKUP_DIR/sugar.sql.tgz ]
            then
                if [ -f $BACKUP_DIR/sugar.sql ]
                then
                    rm $BACKUP_DIR/sugar.sql
                fi
            fi
            echo Repairing system
            ./utilities/runcli.sh php ../repair.php --instance .
            echo System repaired
            echo Restarting cron
            docker restart sugar-cron
            echo Cron restarted
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
