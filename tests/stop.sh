#!/bin/bash
echo Retrieving web log
docker logs sugar-web1
echo Stopping environment
docker-compose -f stacks/sugar8/php71.yml down
