FROM corbinu/docker-nginx-php
MAINTAINER Cody Mize docker@codymize.com

# Set default env
ENV MAX_UPLOAD=50M \
    PMA_SECRET=blowfish_secret \
    PMA_USERNAME=pma \
    PMA_PASSWORD=password \
    MYSQL_USERNAME=mysql \
    MYSQL_PASSWORD=password

# Create $MAX_UPLOAD templates
RUN sed -e 's/http {/http {\n        client_max_body_size $MAX_UPLOAD;/' \
        -i /etc/nginx/nginx.conf && \
    sed -e 's/upload_max_filesize = 2M/upload_max_filesize = $MAX_UPLOAD/' \
        -e 's/post_max_size = 8M/post_max_size = $MAX_UPLOAD/' \
        -i /etc/php5/fpm/php.ini

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    gettext-base \
    mysql-client \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Install phpMyAdmin
ENV PHPMYADMIN_VERSION=4.4.15
RUN wget https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-english.tar.bz2 \
    && tar -xvjf /phpMyAdmin-${PHPMYADMIN_VERSION}-english.tar.bz2 -C / \
    && rm /phpMyAdmin-${PHPMYADMIN_VERSION}-english.tar.bz2 \
    && rm -r /www \
    && mv /phpMyAdmin-${PHPMYADMIN_VERSION}-english /www

# Copy supervisor conf
COPY sources/supervisord.conf /etc/supervisor/conf.d/

# Copy custom templates
COPY sources/templates /templates

# Copy setup and start scripts
COPY sources/bin /usr/local/bin/
RUN chmod +x /usr/local/bin/*

EXPOSE 80

CMD ["/usr/local/bin/phpmyadmin-start"]
