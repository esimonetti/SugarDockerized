#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

# enter the repo's root directory
REPO="$( dirname ${BASH_SOURCE[0]} )/../../"
cd $REPO

# running
# if it is our repo
if [ -f '.gitignore' ] && [ -d 'data' ]
then
    if [ -d 'data/app/tidbit' ]
    then
        echo 
        echo Tidbit is already installed
        echo
    else
        echo 
        echo Installing tidbit
        echo

        ./utilities/runcli.sh "cd ../ \
            && curl -Ls https://github.com/sugarcrm/Tidbit/archive/master.zip > tidbit.zip \
            && unzip tidbit.zip \
            && rm tidbit.zip \
            && mv Tidbit-master tidbit \
            && cd tidbit \
            && composer install \
            && chmod +x bin/tidbit"
        echo
        echo Installation completed
        echo
        echo Run: ./utilities/runcli.sh \"../tidbit/bin/tidbit -u 200 --as_populate --as_number 1 --as_buffer 1000 --insert_batch_size 500 -o --sugar_path ./sugar\"
    fi
else
    echo The command needs to be executed from within the clone of the repository
fi
