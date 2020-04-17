#!/bin/bash
## Usage: ./startTraefikService.sh
##
## Description
##     Create and start traefik reverse proxy service
##
## Vincent Jaro
## jaro.vincent@gmail.com

REPO="$(dirname ${BASH_SOURCE[0]})/../../"
cd $REPO

#https://docs.docker.com/engine/reference/commandline/ps/
if [ "$(docker ps -aq -f name=traefikv2_reverse_proxy)" ]; then
  echo "The traefikv2_reverse_proxy already exists. Checking for availability..."
  if [ "$(docker ps -aq -f status=running -f name=traefikv2_reverse_proxy)" ]; then
    echo "The traefikv2_reverse_proxy is running..."
  fi

  if [ "$(docker ps -aq -f status=exited -f name=traefikv2_reverse_proxy)" ]; then
    echo "The traefikv2_reverse_proxy service is not running. Restarting..."
    docker restart traefikv2_reverse_proxy
  fi
else
  echo "The traefikv2_reverse_proxy container is missing. Instantiating the container..."
  docker-compose -f stacks/reverseproxy/traefikv2/docker-compose.yml up -d
fi
