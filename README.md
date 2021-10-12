/bin/wp-cli.phar --allow-root core update
/bin/wp-cli.phar --allow-root plugin update --all
/bin/wp-cli.phar --allow-root theme update --all

/bin/wp-cli.phar --allow-root core update-db

sudo chown -R ${MAIN_USER}:${MAIN_GROUP}

## Wordpress batch updater

This project try to run/update all the wordpress inside the folder `projects` with a classic [MySQL](https://hub.docker.com/_/mysql)/[Phpmyadmin](https://hub.docker.com/_/phpmyadmin)/[Wordpress](https://hub.docker.com/r/conetix/wordpress-with-wp-cli/) stack.

All the projects share the same istance of Mysql and Phpmyadmin, and every wordpress has his own instance.

## Initialize the project

- Download your wordpress repo inside the `projects` folder, es. `projects/{wordpressname}`
- Append your project to the `docker-compose.yml`.

    ---
        {folder-name}:
            image: conetix/wordpress-with-wp-cli
            container_name: {folder-name}
            restart: always
            ports:
            - '81:80'
            environment:
            WORDPRESS_DB_HOST: {db}
            WORDPRESS_DB_USER: {user}
            WORDPRESS_DB_PASSWORD: {pass}
            WORDPRESS_DB_NAME: {dbname}
            volumes:
            - './projects/{folder-name}:/var/www/html'
    ---
- Set up your wordpress installation, es. Connection

## Upgrade core and plugins

To upgrade you have to launch `./update.sh` with this params:

| Option name | desc                                                  | default                   |
|-------------|-------------------------------------------------------|---------------------------|
| -c          | If present it create a commit with the upgraded files |                           |
| -b          | Switch the branch on which apply the commit           | ""                        |
| -m          | Message of the commit                                 | "Updated core and plugin" |
| -u          | Set the folder user                                   | id -u -n                  |
| -g          | Set the folder group                                  | id -u -n                  |

> The upgrade procedure only affect the running container 

## TODO

- [ ] Go lang
- [ ] Select the project to update

## Next step

Creare un immagine go, che lancia uno script che va a prendere le immagini elencate in una variabile settata al run dell'immagine.

Da questo elenco vado a prendere l'immagine, la faccio partire, lancio i 3/4 script e via.