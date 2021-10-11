#!/bin/bash

for d in projects/*/
do
    FOLDER_NAME="$(basename "$d")"
    echo "Processing: ${FOLDER_NAME}"
    docker-compose up -d $FOLDER_NAME

    docker-compose exec $FOLDER_NAME /bin/wp-cli.phar --allow-root core update
    docker-compose exec $FOLDER_NAME /bin/wp-cli.phar --allow-root core update-db
    docker-compose exec $FOLDER_NAME /bin/wp-cli.phar --allow-root plugin update --all
    docker-compose exec $FOLDER_NAME /bin/wp-cli.phar --allow-root theme update --all

    docker-compose exec $FOLDER_NAME sudo chown -R ${MAIN_USER}:${MAIN_GROUP}

    docker-compose stop $FOLDER_NAME
done