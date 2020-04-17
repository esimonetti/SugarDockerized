#!/bin/bash
## Usage: ./stopProject.sh
##
## Description
##     Stops and removes the project created from stack configuration
##
## Vincent Jaro
## jaro.vincent@gmail.com

REPO="$(dirname ${BASH_SOURCE[0]})/../"
cd $REPO

PROJECT_CONF=data/project/project.conf
PROJECT_CONTAINERS_CONF=data/project/containers.conf

source $PROJECT_CONF

echo ""
echo "Stopping services for project $PROJECT_NAME..."
CID=$(docker ps -aq -f name=$PROJECT_NAME)
if [ "$CID" ]; then
  echo "--------------------------------------------------"
  docker-compose -f $TRAEFIK_COMPOSE_FILE -p $PROJECT_NAME down
  echo "--------------------------------------------------"

  echo ""
  echo "Removing the $PROJECT_CONTAINERS_CONF file..."
  rm $PROJECT_CONTAINERS_CONF
else
  echo "------------------------------------------------------------"
  echo "No containers found for project '$PROJECT_NAME'. Exiting..."
  echo "------------------------------------------------------------"
fi
