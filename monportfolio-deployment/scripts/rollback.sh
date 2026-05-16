#!/bin/bash

# Rollback script for MonPortfolio deployment

# Define the Docker container names
CONTAINER_NAME="monportfolio"
PREVIOUS_CONTAINER_NAME="monportfolio_previous"

# Stop the current container
echo "Stopping the current container..."
docker stop $CONTAINER_NAME

# Remove the current container
echo "Removing the current container..."
docker rm $CONTAINER_NAME

# Start the previous container
echo "Starting the previous container..."
docker start $PREVIOUS_CONTAINER_NAME

echo "Rollback completed successfully."