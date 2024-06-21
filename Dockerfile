FROM php:8.0-apache

# Install dependencies
RUN	apt-get update \
	&& apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libpq-dev libzip-dev libxslt1-dev libxml2-dev unzip \
	&& apt-get clean \
	&& a2enmod rewrite \
	&& docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
	&& docker-php-ext-install bcmath gd mysqli pdo pdo_mysql pgsql zip soap xsl \
	&& apt-get remove -y libxslt1-dev icu-devtools libicu-dev libxml2-dev \
    	&& rm -rf /var/lib/apt/lists/*

RUN 	apt-get -y update \
	&& apt-get install -y libicu-dev \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install intl

# Fix server timezone 
RUN 	apt-get -y install gcc make autoconf libc-dev pkg-config \
    	&& pecl install timezonedb \
    	&& bash -c "echo extension=timezonedb.so > /usr/local/etc/php/conf.d/docker-php-ext-timezonedb.ini"

ENV 	FS_VERSION 2022.7

# Download FacturaScripts
ADD 	https://facturascripts.com/DownloadBuild/1/${FS_VERSION} /tmp/facturascripts.zip

# Unzip
RUN 	unzip -q /tmp/facturascripts.zip -d /usr/src/; \
	rm -rf /tmp/facturascripts.zip

VOLUME 	/var/www/html

COPY 	facturascripts.sh /usr/local/bin/facturascripts
RUN 	chmod +x /usr/local/bin/facturascripts
CMD 	["facturascripts"]
