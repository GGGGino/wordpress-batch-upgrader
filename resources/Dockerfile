FROM wordpress:apache

# Add sudo in order to run wp-cli as the www-data user 
RUN apt-get update && apt-get install -y sudo less

COPY --from=wordpress:cli /usr/local/bin/wp /usr/local/bin/wp