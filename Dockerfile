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
  mysqli \
  pdo_mysql \
  xsl \
  zip

COPY mysql mysql
RUN ( \
        cd mysql \
        && phpize \
        && ./configure \
        && make \
        && make install \
    ) \
    && rm -r mysql \
    && docker-php-ext-enable mysql

RUN pecl install redis \
  && docker-php-ext-enable redis

RUN docker-php-ext-enable opcache
    
RUN a2enmod rewrite    
RUN a2enmod ssl
# Apache security
#RUN mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf-back
#COPY ./config/apache/apache2.conf /etc/apache2/apache2.conf

RUN mv /etc/apache2/conf-available/security.conf /etc/apache2/conf-available/security.conf-back
COPY ./config/apache/security.conf /etc/apache2/conf-available/security.conf

COPY ./config/apache/001-default-ssl.conf /etc/apache2/sites-enabled/001-default-ssl.conf

COPY config/php/php.ini /usr/local/etc/php/
