#!/bin/bash
echo Cloning repository
git clone https://github.com/esimonetti/SugarDockerized.git sugardocker
cd sugardocker
echo Starting environment
docker-compose -f stacks/sugar8/php71.yml up -d --build
