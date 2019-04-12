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
            && curl -Ls https://github.com/sugarcrm/Tidbit/archive/develop.zip > tidbit.zip \
            && unzip tidbit.zip \
            && rm tidbit.zip \
            && mv Tidbit-develop tidbit \
            && cd tidbit \
            && chmod +x bin/tidbit \
            && composer install"
        echo
        echo Installation completed
        echo
        echo Run: ./utilities/runcli.sh \"../tidbit/bin/tidbit --profile baseline -c --parallel 8 --sugar_path ./sugar\"
    fi
else
    echo The command needs to be executed from within the clone of the repository
fi
