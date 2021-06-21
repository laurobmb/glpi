FROM ubuntu:latest
LABEL maintainer="Lauro Gomes <laurobmb@gmail.com>"
ENV TZ=America/Fortaleza

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -yq apache2 php libapache2-mod-php
RUN apt-get install -yq php-json php-gd php-curl php-mysql php-mbstring php-zip php-cas php-bz2
RUN apt-get install -yq php-xml php-cli php-imap php-ldap php-xmlrpc php-apcu php-intl
RUN apt-get install -yq software-properties-common
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
RUN apt-get install -yq wget git vim curl zip unzip npm

RUN wget https://github.com/edgardmessias/glpi-singlesignon/releases/download/v1.2.0/singlesignon.tar.gz -P /tmp
RUN wget https://github.com/glpi-project/glpi/archive/9.5.3.tar.gz -P /tmp

COPY ./files/php.ini /etc/php/7.4/apache2/php.ini
COPY ./files/php.ini /etc/php/7.4/cli/php.ini
COPY VirtualHost.conf /etc/apache2/sites-available/000-default.conf

RUN curl -sS https://getcomposer.org/installer |  php -- --install-dir=/usr/local/bin --filename=composer
RUN tar -xvzf /tmp/9.5.3.tar.gz glpi-9.5.3
RUN mv glpi-9.5.3 /var/www/html/glpi
RUN tar -xvzf /tmp/singlesignon.tar.gz -C /var/www/html/glpi/plugins/

WORKDIR /var/www/html/glpi/
RUN php bin/console dependencies install

COPY glpi-start.sh /usr/local/bin
COPY ./files/glpi.conf /etc/apache2/conf-available/glpi.conf 
COPY .env /root/

RUN chown -R www-data:www-data /var/www
RUN chmod +x /usr/local/bin/glpi-start.sh

ENV MYSQL_HOST="MYSQL_HOST"
ENV MYSQL_USER="MYSQL_USER"
ENV MYSQL_PASSWORD="MYSQL_PASSWORD"
ENV MYSQL_DATABASE="MYSQL_DATABASE"
ENV AMBIENT="NEW"

RUN a2enmod rewrite
EXPOSE 80
RUN ["glpi-start.sh"]
