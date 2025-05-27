FROM php:8.1-apache

# Install dependencies
RUN	apt-get update 
RUN	apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libpq-dev libzip-dev libxslt1-dev libxml2-dev unzip
RUN	apt-get clean
RUN	a2enmod rewrite
RUN	docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN	docker-php-ext-install bcmath gd mysqli pdo pdo_mysql pgsql zip soap xsl
RUN	apt-get remove -y libxslt1-dev icu-devtools libicu-dev libxml2-dev
RUN    	rm -rf /var/lib/apt/lists/*

RUN 	apt-get -y update
RUN	apt-get install -y libicu-dev
RUN	docker-php-ext-configure intl
RUN	docker-php-ext-install intl

#fix server timezone. 
RUN 	apt-get -y install gcc make autoconf libc-dev pkg-config
RUN    	pecl install timezonedb
RUN     bash -c "echo extension=timezonedb.so > /usr/local/etc/php/conf.d/docker-php-ext-timezonedb.ini"

ENV 	FS_VERSION 2024.95

# Download FacturaScripts
ADD 	https://facturascripts.com/DownloadBuild/1/${FS_VERSION} /tmp/facturascripts.zip

# Unzip
RUN 	unzip -q /tmp/facturascripts.zip -d /usr/src/; \
	rm -rf /tmp/facturascripts.zip

VOLUME 	/var/www/html

COPY 	facturascripts.sh /usr/local/bin/facturascripts
RUN 	chmod +x /usr/local/bin/facturascripts
CMD 	["facturascripts"]
