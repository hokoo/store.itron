#!/bin/bash

# create .env from example
echo "Create .env from example"
if [ ! -f ./.env ]; then
    echo "File .env doesn't exist. Recreating..."
    cp ./dev-local/.example/.env.example ./.env && echo "Ok."
else
    echo "File .env already exists."
fi

# import variables from .env file
. ./.env

# configure nginx.conf
echo "${RCYAN}nginx.conf ...${COLOR_OFF}"
[ ! -d ./dev-local/nginx/ ] && mkdir -p ./dev-local/nginx/
if [ ! -f ./dev-local/nginx/nginx.conf ]; then
  NGINXCONFIG=$(< ./dev-local/.example/nginx.conf.template)
  printf "$NGINXCONFIG" $PROJECT_BASE_URL $PROJECT_BASE_URL $PROJECT_BASE_URL $PROJECT_BASE_URL > ./dev-local/nginx/nginx.conf
fi
echo "Ok."

echo "Creating access.log error.log  ..."
touch dev-local/nginx/access.log
touch dev-local/php-fpm/error.log
echo "Ok."
