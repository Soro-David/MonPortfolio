#!/bin/bash

# Navigate to the MonPortfolio directory
cd /path/to/monportfolio-deployment/MonPortfolio

# Pull the latest code from the repository
git pull origin main

# Build the Docker containers
docker-compose -f ../docker-compose.prod.yml build

# Restart the services
docker-compose -f ../docker-compose.prod.yml up -d

# Clean up unused Docker images and containers
docker system prune -f

echo "Deployment completed successfully."