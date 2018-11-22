#!/bin/bash

# get into the correct directory
REPO="$( dirname ${BASH_SOURCE[0]} )/../"
cd $REPO
./utilities/runcli.sh "php ../repair.php --instance ."
