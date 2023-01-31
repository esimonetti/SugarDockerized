#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

# enter the repo's root directory
REPO="$( dirname ${BASH_SOURCE[0]} )/../"
cd $REPO


# include stack configuration
. ./utilities/stacks.conf

if [ -z $1 ] || [ -z $2 ]
then
    echo Provide two parameters. The sugar stack version keyword for \(eg: 80, 90\) and the action \(up, down\). The stacks keywords available can be found below:
    for index in "${stacks[@]}" ; do
        KEY="${index%%::*}"
        echo $KEY
    done
else
    # based on the solution of literal key/values for old bash versions described here
    #https://stackoverflow.com/questions/6047648/bash-4-associative-arrays-error-declare-a-invalid-option
    for index in "${stacks[@]}" ; do
        KEY="${index%%::*}"
        VALUE="${index##*::}"
        if [ "$KEY" == $1 ]; then
            STACKFILE=$VALUE
            break
        fi
    done

    # if it is our repo, and the source exists, and the destination does not
    if [ -f '.gitignore' ] && [ -d 'data' ] && [ ! -z $STACKFILE ] && [ -f $STACKFILE ]
    then
        # check if the stack is running
        RUNNING=`docker ps | grep sugar-web1 | wc -l`

        if [ $RUNNING -gt 0 ] && [ $2 == 'up' ]
        then
            echo A stack is running, please take the stack down first
        else
            echo $STACKFILE $2

            if [ $2 == 'down' ]
            then
                if [ $RUNNING -eq 0 ]
                then
                    echo The stack is already down, skipping
                else
                    docker-compose -f $STACKFILE down
                    docker-compose -f $STACKFILE rm
                fi
            else
                if [ $2 == 'up' ]
                then
                    docker-compose -f $STACKFILE up -d --build
                else
                    echo The action $2 is not applicable
                fi
            fi

            echo Checking for a newer SugarDockerized version, please wait...
            NEEDSUPGRADE=`./utilities/sugardockerized/checkversion.sh`
            echo Done.
            if $NEEDSUPGRADE
            then
                echo
                echo --------------------------------------------------------------------------------------------------------------------------------
                echo Your SugarDockerized needs to be upgraded, please execute ./utilities/sugardockerized/selfupgrade.sh to proceed with the upgrade
                echo --------------------------------------------------------------------------------------------------------------------------------
                echo
            fi

            echo
            echo
            echo If you find this sofware useful, please consider supporting the work that went into it, with a monthly amount
            echo Please visit the original repo: https://github.com/esimonetti/SugarDockerized for details
            echo Thank you!
            echo
            echo
        fi
    else
        if [ ! -d 'data' ]
        then
            echo \"data\" cannot be empty, the command needs to be executed from within the clone of the repository
        fi

        if [ -z $STACKFILE ] || [ ! -f $STACKFILE ]
        then
            echo The stack keyword $1 does not exist on your configuration file. The stacks keywords available can be found below:
            for index in "${stacks[@]}" ; do
                KEY="${index%%::*}"
                echo $KEY
            done
        fi
    fi
fi
