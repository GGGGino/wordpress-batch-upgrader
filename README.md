/bin/wp-cli.phar --allow-root core update
/bin/wp-cli.phar --allow-root plugin update --all
/bin/wp-cli.phar --allow-root theme update --all

/bin/wp-cli.phar --allow-root core update-db

sudo chown -R ${MAIN_USER}:${MAIN_GROUP}

## Idea 1

Creare un immagine go, che lancia uno script che va a prendere le immagini elencate in una variabile settata al run dell'immagine.

Da questo elenco vado a prendere l'immagine, la faccio partire, lancio i 3/4 script e via.