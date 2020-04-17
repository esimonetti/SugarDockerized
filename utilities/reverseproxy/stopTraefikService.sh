#!/bin/bash
## Usage: ./stopTraefikService.sh
##
## Description
##     Stop and remove traefik reverse proxy service and containers
##
## Vincent Jaro
## jaro.vincent@gmail.com

REPO="$(dirname ${BASH_SOURCE[0]})/../../"
cd $REPO

#https://docs.docker.com/engine/reference/commandline/ps/
if [ "$(docker ps -aq -f name=traefikv2_reverse_proxy)" ]; then
  echo "Removing traefikv2_reverse_proxy container..."
  docker-compose -f stacks/reverseproxy/traefikv2/docker-compose.yml down
else
  echo "There is no traefikv2_reverse_proxy container..."
fi
