#!/bin/bash
if [ -f /var/www/index.php ]; then
   echo "Wordpress installed"
else
    echo "Wordpress install"
    wget -P /var/www/ https://wordpress.org/latest.tar.gz;
    tar -xzvf /var/www/latest.tar.gz -C /var/www/;
    mv -f /var/www/wordpress/* /var/www/;
    rm /var/www/latest.tar.gz;
    rm -r /var/www/wordpress;
    chown -R www-data:www-data /var/www/;

    wget -P /var/www/  https://files.phpmyadmin.net/phpMyAdmin/4.8.4/phpMyAdmin-4.8.4-all-languages.tar.gz;
    mkdir /var/www/pma/;
    tar -xzvf /var/www/phpMyAdmin-4.8.4-all-languages.tar.gz -C /var/www/;
    mv -f /var/www/phpMyAdmin-4.8.4-all-languages/* /var/www/pma/;
    rm /var/www/phpMyAdmin-4.8.4-all-languages.tar.gz;
    rm -r /var/www/phpMyAdmin-4.8.4-all-languages;
    rm /var/www/pma/config.inc.php;
    cp /config.inc.php /var/www/pma/;
    
    chown -R www-data:www-data /var/www/;
    find /var/www/ -type d -exec chmod 755 {} \;
    find /var/www/ -type f -exec chmod 644 {} \;


fi

php-fpm7 -F
