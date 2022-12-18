FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

#######################
## install webserver ##
#######################

RUN apt-get -qq update && apt-get -qq install software-properties-common curl zip unzip git supervisor dos2unix > /dev/null

RUN add-apt-repository -y ppa:ondrej/apache2 > /dev/null
RUN add-apt-repository -y ppa:ondrej/php > /dev/null

RUN apt-get -qq update && apt-get -qq upgrade && apt-get -qq install htop vim apache2 php7.4 libapache2-mod-php7.4 php7.4-common php7.4-mbstring php7.4-xmlrpc php7.4-gd php7.4-xml php7.4-mysqli php7.4-cli php7.4-zip php7.4-curl php7.4-curl php7.4-imagick php7.4-dev php7.4-yaml php7.4-redis php7.4-memcached php7.4-soap > /dev/null
RUN apt-get -qq update && apt-get -qq install php-pear phpunit zlib1g-dev > /dev/null

# Switch to php7.4-FPM & event worker
RUN apt-get -y -qq update && apt-get install -qq php7.4-fpm libapache2-mod-fcgid > /dev/null
RUN a2dismod php7.4
RUN a2dismod mpm_prefork
RUN a2enmod mpm_event proxy proxy_fcgi setenvif
RUN a2enconf php7.4-fpm
RUN mkdir -p /run/php

# Add composer
RUN curl -s https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Enable apache2 mods
RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod ssl
RUN a2enmod env
RUN a2enmod remoteip

# Config apache2 PHP
#RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.4/fpm/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.4/fpm/php.ini
RUN sed -i "s/upload_max_filesize = .*$/upload_max_filesize = 128M/" /etc/php/7.4/fpm/php.ini
RUN sed -i "s/post_max_size = .*$/post_max_size = 128M/" /etc/php/7.4/fpm/php.ini

# Config cli PHP
#RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.4/cli/php.ini

# Apache2 env vars
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Allow .htaccess
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/c\
<Directory /var/www/>\n\
        Options -Indexes +FollowSymLinks\n\
        AllowOverride All\n\
        Require all granted\n\
</Directory>' /etc/apache2/apache2.conf

# Alter port
RUN sed -i "s/Listen 80$/Listen 8123/" /etc/apache2/ports.conf

# Vhost(s)
RUN rm -Rf /etc/apache2/sites-available/*
RUN rm -Rf /etc/apache2/sites-enabled/*
ADD vhosts /etc/apache2/sites-available
RUN ls /etc/apache2/sites-available | xargs a2ensite

# Add PHP-FPM settings
ADD php-fpm-pool.conf /etc/php/7.4/fpm/pool.d/www.conf

#########
## RUN ##
#########

WORKDIR /app

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD chown www-data:www-data /app/uploads && /usr/bin/supervisord