GRANT ALL PRIVILEGES ON phpmyadmin.* TO  '$PMA_USERNAME'@'%'
IDENTIFIED BY '$PMA_PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
