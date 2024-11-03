#!/bin/bash

echo "WP setup preparing..."

# import variables from .env file
. ./.env

# prepare file structure
if [ ! -f wp-config.php ]; then
  WPCONFIG=$(< ./dev-local/.example/wp-config.php.template)
  printf "$WPCONFIG" $PROJECT_BASE_URL $PROJECT_BASE_URL $DB_NAME $DB_USER $DB_PASSWORD $DB_HOST $PROJECT_BASE_URL > ./wp-config.php
fi

# Replace {{ wp_environment_type }} with 'local'.
sed -i 's/{{ wp_environment_type }}/local/g' ./wp-config.php

# install WP
echo -n "Would you import database from db.sql (y), init new instance (i), or do nothing (n)? (y/n/i)"

read item
case "$item" in
    y|Y)
    echo "WP database import..."
    wp db import db.sql
      ;;

    i|I)
    echo "WP database init new instance..."

    # Preserve the current database if it exists.
    wp db export 2>/dev/null

    wp db reset --yes
    wp core install --url=$PROJECT_BASE_URL --title="$WP_TITLE" --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_EMAIL --skip-email
    wp plugin delete akismet hello
    wp plugin activate --all
    wp theme activate kadence

    # Some additional configurations.
    wp option update show_on_front page && \
    wp option update page_on_front 2 && \
    wp rewrite structure '/%postname%/'

    echo -e "${RCYAN}The project is ready now.${COLOR_OFF}" && \
    echo -e "${ICYAN}WordPress credentials:${COLOR_OFF}" && \
    printf "WP User Admin: ${RYELLOW}%s \n${COLOR_OFF}WP User Pass:  ${RYELLOW}%s${COLOR_OFF}\n" $WP_ADMIN $WP_ADMIN_PASS
      ;;

    *)
      echo "WP database has not been touched."
      ;;
esac

echo -e "${ON_CYAN}Do not forget renew your hosts file 127.0.0.1 store.itron.local${COLOR_OFF}"
echo -e "${RGREEN}Done.${COLOR_OFF}"
