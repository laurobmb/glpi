FROM ubuntu:latest
LABEL maintainer="Lauro Gomes <laurobmb@gmail.com>"

ENV TZ=America/Fortaleza
ENV VERSION=9.5.3
ENV DEBIAN_FRONTEND=noninteractive
ENV MYSQL_HOST="MYSQL_HOST"
ENV MYSQL_USER="MYSQL_USER"
ENV MYSQL_PASSWORD="MYSQL_PASSWORD"
ENV MYSQL_DATABASE="MYSQL_DATABASE"
ENV AMBIENT="NEW"

RUN apt-get update
RUN apt-get install -yq apache2 php \
        libapache2-mod-php \
        php-json \
        php-gd \
        php-curl \
        php-mysql \
        php-mbstring \
        php-zip \
        php-cas \
        php-bz2 \
        php-xml \
        php-cli \
        php-imap \
        php-ldap \
        php-xmlrpc \
        php-apcu \
        php-intl \
        software-properties-common \
        wget \
        git \
        vim \
        curl \
        zip \
        unzip \
        npm

RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 &\
    wget https://github.com/edgardmessias/glpi-singlesignon/releases/download/v1.2.0/singlesignon.tar.gz -P /tmp &\
    wget https://github.com/glpi-project/glpi/archive/${VERSION}.tar.gz -P /tmp

COPY ./files/php.ini /etc/php/7.4/apache2/php.ini
COPY ./files/php.ini /etc/php/7.4/cli/php.ini
COPY VirtualHost.conf /etc/apache2/sites-available/000-default.conf

RUN curl -sS https://getcomposer.org/installer |  php -- --install-dir=/usr/local/bin --filename=composer ;\
    tar -xvzf /tmp/${VERSION}.tar.gz glpi-${VERSION}  ;\
    mv glpi-${VERSION} /var/www/html/glpi ;\
    tar -xvzf /tmp/singlesignon.tar.gz -C /var/www/html/glpi/plugins/ 

WORKDIR /var/www/html/glpi/

RUN php bin/console dependencies install

COPY glpi-start.sh /usr/local/bin
COPY ./files/glpi.conf /etc/apache2/conf-available/glpi.conf 
COPY .env /root/

RUN chown -R www-data:www-data /var/www &\
    chmod +x /usr/local/bin/glpi-start.sh

RUN a2enmod rewrite
EXPOSE 80
ENTRYPOINT ["glpi-start.sh"]
