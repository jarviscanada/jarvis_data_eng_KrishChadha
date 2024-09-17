#!/bin/sh

# Capture CLI arguments
cmd=$1
db_username=$2
db_password=$3

# Start Docker if it's not already running
sudo systemctl status docker || sudo systemctl start docker

# Check container status
docker container inspect jrvs-psql > /dev/null 2>&1
container_status=$?

# Use case statement to handle create|start|stop options
case $cmd in 
   create)
      # Check if the container is already created
      if [ $container_status -eq 0 ]; then
         echo 'Container already exists'
         exit 1
      fi

      # Check number of CLI arguments
      if [ $# -ne 3 ]; then
         echo 'Create requires username and password'
         exit 1
      fi
      
      # Create a new volume if it doesn't exist
      docker volume create pgdata

      # Run the PostgreSQL container
      docker run --name jrvs-psql -e POSTGRES_USER=$db_username -e POSTGRES_PASSWORD=$db_password -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres:9.6-alpine
      
      # Check if the container was created successfully
      if [ $? -ne 0 ]; then
         echo 'Failed to create the container'
         exit 1
      fi
      
      echo 'Container created successfully'
      exit 0
      ;;

   start|stop)
      # Check if the container has been created
      if [ $container_status -ne 0 ]; then
         echo 'Container has not been created'
         exit 1
      fi
      
      # Start or stop the container
      docker container $cmd jrvs-psql

      # Check if the command was successful
      if [ $? -ne 0 ]; then
         echo "Failed to ${cmd} the container"
         exit 1
      fi
      
      echo "Container ${cmd}ed successfully"
      exit 0
      ;;
      
   *)
      echo 'Illegal command'
      echo 'Commands: start|stop|create'
      exit 1
      ;;
esac
