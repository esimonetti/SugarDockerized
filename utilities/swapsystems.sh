#!/bin/bash

if [ -z $1 ] || [ -z $2 ]
then
    echo Provide the future backup directory and the current backup directory as script parameters.
    echo eg: customer_system_data clean_system_data: would move the current data into customer_system_data, and restore clea_nsystem_data into data
else
    # check if the stack is running
    running=`docker ps | grep sugar-web1 | wc -l`

    if [ $running -gt 0 ]
    then
        # running
        echo The stack is running, please stop the stack first
    else
        # not running
        echo Moving \"data\" to \"$1\" and \"$2\" to \"data\"

        # exit utilities directory if in there
        #current_dir=`pwd`
        #if [ ${current_dir: -10} == '/utilities' ]
        #then
        #    cd ..
        #fi
    
        # if it is our repo, and the source exists, and the destination does not
        if [ -f '.gitignore' ] && [ -d 'data' ] && [ $1 != 'data' ] && [ $2 != 'data' ] && [ -d $2 ]  && [ ! -d $1 ]
        then
            echo Moving data to $1
            mv data $1
            echo Moving $2 to data
            mv $2 data
            echo You can now start the system with the content of $2
        else
            #echo The repository seems to have a problem

            if [ $1 == 'data' ] || [ $2 == 'data' ]
            then    
                echo The empty backup directory or the source directory cannot be data!
            fi
        
            if [ ! -d 'data' ]
            then
                echo \"data\" cannot be empty, the command needs to be executed from within the clone of the repository
            fi

            if [ ! -d $2 ]
            then
                echo $2 does not exist
            else
                if [ -d $1 ]
                then
                    echo $1 exists already
                fi
            fi
        fi
    fi
fi
