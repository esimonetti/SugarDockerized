#!/bin/bash
## Usage: ./startProject.sh
##
## Description
##     Deploy a project stack behind traefik's v2 reverse proxy
##
## Vincent Jaro
## jaro.vincent@gmail.com

REPO="$(dirname ${BASH_SOURCE[0]})/../"
cd $REPO

PROJECT_CONTAINERS_CONF=data/project/containers.conf
PROJECT_CONF=data/project/project.conf

echo ""
if [ -f "$PROJECT_CONTAINERS_CONF" ]; then
  source $PROJECT_CONF

  echo "Starting Traefikv2 service.."
      ./utilities/reverseproxy/startTraefikService.sh
  echo "-----------------------------------------------------------------------"
  echo ""

  echo "Restarting the project containers..."
  echo "-----------------------------------------------------------------------"
  docker-compose -f $TRAEFIK_COMPOSE_FILE -p $PROJECT_NAME restart

else
  if [ -f "$PROJECT_CONF" ]; then
    source $PROJECT_CONF

    if [ -f "$STACK_FILE" ]; then
      echo "Starting Traefikv2 service.."
      ./utilities/reverseproxy/startTraefikService.sh
      echo "-----------------------------------------------------------------------"

      echo ""
      echo "Checking web server and db server mapped ports..."
      echo ""

      ./utilities/reverseproxy/checkPortAvailability.sh $WEB_SERVER_PORT
      WEB_SERVER_PORT_CHECK=$?
      ./utilities/reverseproxy/checkPortAvailability.sh $DB_SERVER_PORT
      DB_SERVER_PORT_CHECK=$?

      echo ""
      if [ $WEB_SERVER_PORT_CHECK -eq 0 ] && [ $DB_SERVER_PORT_CHECK -eq 0 ]; then
        echo "Ports $WEB_SERVER_PORT and $DB_SERVER_PORT is available..."
        echo ""

        STACK_DIR="$(dirname "$STACK_FILE")"
        STACK_FILENAME=$(basename "$STACK_FILE" .template.yml)
        TRAEFIK_COMPOSE_FILE="$STACK_DIR/$STACK_FILENAME.yml"

        echo "Creating traefik compose file $TRAEFIK_COMPOSE_FILE based on template..."
        cp $STACK_FILE $TRAEFIK_COMPOSE_FILE

        echo "Updating traefik compose file $TRAEFIK_COMPOSE_FILE based on project.conf values..."
        sed -i -e "s/{PROJECT_NAME}/$PROJECT_NAME/" \
          -i -e "s/{WEB_SERVER_PORT}/$WEB_SERVER_PORT/" \
          -i -e "s/{DB_SERVER_PORT}/$DB_SERVER_PORT/" \
          -i -e "s/{PROJECT_HOST_NAME}/$PROJECT_HOST_NAME/" ${TRAEFIK_COMPOSE_FILE}

        echo "TRAEFIK_COMPOSE_FILE=$TRAEFIK_COMPOSE_FILE" >>$PROJECT_CONF

        echo "-----------------------------------------------------------------"
        echo ""
        echo "Creating project '$PROJECT_NAME' based on stack file $TRAEFIK_COMPOSE_FILE ..."
        docker-compose -f $TRAEFIK_COMPOSE_FILE -p $PROJECT_NAME up -d
        echo ""
        echo "Storing project container names..."
        docker ps -a -f name=$PROJECT_NAME --format {{.Names}} >$PROJECT_CONTAINERS_CONF

        SUGAR_WEB_CONTAINER=$(cat "$PROJECT_CONTAINERS_CONF" | grep web)
        SUGAR_REDIS_CONTAINER=$(cat "$PROJECT_CONTAINERS_CONF" | grep redis)

        if [ ! -z "$SUGAR_WEB_CONTAINER" ] && [ ! -z "$SUGAR_REDIS_CONTAINER" ]; then
          DOCKER_INI_FILE=data/php/docker.ini
          if [ ! -f "$DOCKER_INI_FILE" ]; then
            mkdir -p data/php && touch $DOCKER_INI_FILE
          fi

          echo "Updating docker.ini and restarting web server..."
          docker cp $SUGAR_WEB_CONTAINER:/usr/local/etc/php/conf.d/docker.ini $DOCKER_INI_FILE
          chmod 777 $DOCKER_INI_FILE
          sed -i -e "s/sugar-redis/$SUGAR_REDIS_CONTAINER/" $DOCKER_INI_FILE
          docker cp $DOCKER_INI_FILE $SUGAR_WEB_CONTAINER:/usr/local/etc/php/conf.d/docker.ini
          docker restart $SUGAR_WEB_CONTAINER
        fi

      else

        echo "Some ports are already being used by other process. Check output for details..."
      fi
    else
      echo "$STACK_FILE does not exist. Exiting.."
    fi
  else
    echo "$PROJECT_CONF does not exist. Create the file based on the data/project/project.conf"
  fi
fi
echo "---------------------------------------------------------------------------------"
