FROM corbinu/docker-nginx-php
MAINTAINER Cody Mize docker@codymize.com

RUN apt-get update && apt-get install -y mysql-client \
    && rm -rf /var/lib/apt/lists/*

ENV PMA_SECRET=blowfish_secret \
    PMA_USERNAME=pma \
    PMA_PASSWORD=password \
    MYSQL_USERNAME=mysql \
    MYSQL_PASSWORD=password \
    PHPMYADMIN_VERSION=4.4.15 \
    MAX_UPLOAD=50M

RUN wget https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-english.tar.bz2 \
    && tar -xvjf /phpMyAdmin-${PHPMYADMIN_VERSION}-english.tar.bz2 -C / \
    && rm /phpMyAdmin-${PHPMYADMIN_VERSION}-english.tar.bz2 \
    && rm -r /www \
    && mv /phpMyAdmin-${PHPMYADMIN_VERSION}-english /www

COPY sources/config.inc.php sources/create_user.sql /
COPY sources/phpmyadmin-* /usr/local/bin/

RUN chmod +x /usr/local/bin/phpmyadmin-*

RUN sed -i "s/http {/http {\n        client_max_body_size $MAX_UPLOAD;/" /etc/nginx/nginx.conf \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = $MAX_UPLOAD/" /etc/php5/fpm/php.ini \
    && sed -i "s/post_max_size = 8M/post_max_size = $MAX_UPLOAD/" /etc/php5/fpm/php.ini

EXPOSE 80

CMD phpmyadmin-start
