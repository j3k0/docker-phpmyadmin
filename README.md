Docker PHPMyAdmin
=================

First off it appears this little container I set up for myself has gotten a lot more popular then I expected. I promise to be much more diligent about updates and will be looking to make improvements. Please feel free to make suggestions

Current PHPMyAdmin Version 4.6.6

* Debian 8.2
* PHP 5.6
* Nginx Mainline
* MySQL 5.6
* PHPMyAdmin 4.6.6 (configurable with Environment Variable)

## Start MySQL

`docker run --name phpmyadmin-mysql -e MYSQL_ROOT_PASSWORD=password -d mysql`

## Start PHPMyAdmin
`docker run -d --link phpmyadmin-mysql:mysql -e MYSQL_USERNAME=root --name phpmyadmin -p 80 kingcody/phpmyadmin`
