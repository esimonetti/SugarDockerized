#!/bin/bash

# get into the correct directory
REPO="$( dirname ${BASH_SOURCE[0]} )/../"
cd $REPO
./utilities/toothpaste.sh "local:system:repair --instance=../sugar"
