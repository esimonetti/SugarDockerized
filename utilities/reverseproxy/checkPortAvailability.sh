#!/bin/bash
## Usage: ./checkPortAvailability.sh PORT_NUMBER
##
## Description
##     Check if the PORT_NUMBER supplied is available
##
## Vincent Jaro
## jaro.vincent@gmail.com

#https://unix.stackexchange.com/questions/413321/simple-bashscript-for-checking-open-port
PORT_USED=0
if nc -zv 127.0.0.1 $1 2>&1; then
  PORT_USED=1
fi
exit $PORT_USED
