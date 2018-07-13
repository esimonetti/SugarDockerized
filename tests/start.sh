#!/bin/bash
echo Starting environment
docker-compose -f stacks/sugar8/php71.yml up -d --build
