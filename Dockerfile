FROM php:7.0.9-apache
    
RUN apt-get update \
  && apt-get install -y \
    cron \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libxslt1-dev \
    zlib1g-dev

RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
    
RUN docker-php-ext-install \
  gd \
  intl \
  mbstring \
  mcrypt \
  mysql \
  pdo_mysql \
  xsl \
  zip
