#!/bin/bash

# Enrico Simonetti
# enricosimonetti.com

# enter the repo's root directory
REPO="$( dirname ${BASH_SOURCE[0]} )/../../"
cd $REPO

# running
# if it is our repo
if [ -f '.gitignore' ] && [ -d 'data' ] && [ -d 'images/jmeter' ]
then
    if [ -d 'data/jmeter/performance' ]
    then
        echo 
        echo It appears the build and installation process has been already executed
        echo If you want to re-run the build and installation process, please remove the content of ./data/jmeter/ from the root of the repository with: \"sudo rm -rf ./data/jmeter/*\" and try again
        echo Please note that by doing so, you will delete any possible changes you have completed to the jmeter configuration
        echo
    else
        echo 
        echo The Sugar performance repository https://github.com/sugarcrm/performance.git is private, password and access protected. Make sure you have access before proceeding
        echo You will be now requested your github credentials to clone the repository
        echo
        if [ ! -d 'data/jmeter' ]
        then
            echo The directory ./data/jmeter is missing, creating it
            mkdir data/jmeter
        fi

        cd data/jmeter \
            && git clone https://github.com/sugarcrm/performance.git performance \
            && cd performance \
            && git checkout backend-side

        cd ../../../

        # build latest image
        docker build -t sugar-jmeter ./images/jmeter/
        # complete installation process
        docker run -v ${PWD}/data/jmeter:/opt/jmeter -t -i sugar-jmeter bash -c "cp -R /opt/jmeterinstall/jmeter /opt/jmeter/performance"

        echo All set!
        echo  
        echo Run jmeter with: ./utilities/jmeter/run.sh \<ant command here\>
        echo EG: ./utilities/jmeter/run.sh \"ant customerTarget -file build.xml -DHOST_HEADER=10.10.10.10 -DSERVER=10.10.10.10 -DTIMER_DELAY=60000 -DTHREADS=200 -DITERATION_NUM=8 -DREST_ENDPOINT=/sugar/rest/v11_1 -DTHREAD_RAMP_UP=240\"
    fi
else
    echo The command needs to be executed from within the clone of the repository
fi
