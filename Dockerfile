FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    git zip unzip curl libzip-dev libpng-dev libonig-dev libxml2-dev npm \
    && docker-php-ext-install pdo_mysql zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY . /var/www/html

WORKDIR /var/www/html
RUN composer install --no-dev --optimize-autoloader \
    && npm install \
    && npm run prod

RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

RUN a2enmod rewrite

EXPOSE 80