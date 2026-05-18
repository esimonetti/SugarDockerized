#!/bin/bash

# get into the correct directory
REPO="$( dirname ${BASH_SOURCE[0]} )/../"
cd $REPO
echo Repairing system
if [ ! -f ./data/app/sugar/simpleRepair.php ]; then
    cp ./utilities/build/simpleRepair.php ./data/app/sugar
fi
./utilities/runcli.sh "php simpleRepair.php"
echo System repaired
