FROM php:7.4-apache

# Install dependencies
RUN     apt-get update && \
	apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libpq-dev libzip-dev libxslt1-dev unzip && \
	apt-get clean && \
	a2enmod rewrite && \
	service apache2 restart && \
	docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && \
	docker-php-ext-install xsl && \
	docker-php-ext-install bcmath gd mysqli pdo pdo_mysql pgsql zip && \
	apt-get remove -y libxslt1-dev icu-devtools libicu-dev libxml2-dev && \
    	rm -rf /var/lib/apt/lists/*

ENV FS_VERSION 2022.51

# Download FacturaScripts
ADD https://facturascripts.com/DownloadBuild/1/${FS_VERSION} /tmp/facturascripts.zip

# Unzip
RUN unzip -q /tmp/facturascripts.zip -d /usr/src/; \
	rm -rf /tmp/facturascripts.zip

VOLUME /var/www/html

COPY facturascripts.sh /usr/local/bin/facturascripts
RUN chmod +x /usr/local/bin/facturascripts
CMD ["facturascripts"]
