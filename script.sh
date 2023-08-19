#!/bin/bash

# Configuration
SERVICE_NAME="nodejs"       # Replace with your service name in docker-compose.yml
EXPECTED_VERSION="1.0.0"  # Replace with your expected version
DOCKER_COMPOSE_FILE="/home/ubuntu/Nodejs-docker/docker-compose.yml"  # Replace with the actual path

# for the script to run  every hour]
(crontab -l ; echo "0 * * * * /path/to/your/script.sh") | crontab - 

# Function to check app status and restart if needed
check_and_restart() {
  # Check if the service is running
  if sudo docker-compose -f $DOCKER_COMPOSE_FILE ps $SERVICE_NAME | grep -q "Up"; then
    echo "App is running."
    # Check app version
    current_version=$(docker exec -it $(docker-compose -f $DOCKER_COMPOSE_FILE ps -q $SERVICE_NAME) node -e "console.log(require('./package.json').version)")
    if [[ "$current_version" == "$EXPECTED_VERSION" ]]; then
      echo "App version is correct: $current_version"
    else
      echo "App version is incorrect. Restarting..."
      docker-compose -f $DOCKER_COMPOSE_FILE restart $SERVICE_NAME
    fi
  else
    echo "App is not running. Restarting..."
    docker-compose -f $DOCKER_COMPOSE_FILE up -d $SERVICE_NAME
  fi
}

# Main
check_and_restart
