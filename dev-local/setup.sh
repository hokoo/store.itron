#!/bin/bash

# run from project root directory
bash ./dev-local/setup-env.sh

echo "Containers creating..."
docker-compose up -d
echo "Containers created."

echo "Composer install..."
docker-compose exec php sh -c "composer install && bash ./dev-local/setup-wp.sh"
