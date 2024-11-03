#!/bin/bash
echo -n "Script will remove all configs and generated folders. Sure? (y/n) "

read item
case "$item" in
    y|Y)
    rm -rf ./vendor
    rm -rf ./wordpress
    rm -rf ./wp-content/themes
    rm -rf ./wp-content/plugins
    rm -f ./wp-config.php
    rm -f ./dev-local/nginx/access.log
    rm -f ./dev-local/nginx/nginx.conf
    rm -f ./dev-local/php-fpm/error.log
    rm -f ./.env
      ;;

    *)
      echo "Nothing has been done."
      ;;
esac
