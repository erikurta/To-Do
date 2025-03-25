# Этап 1: Build frontend
FROM node:16 AS build

WORKDIR /app

COPY package*.json ./
COPY webpack.mix.js ./
COPY resources/ resources/

RUN npm install
RUN npm run prod

# Этап 2: PHP + Apache
FROM php:8.2-apache

# Установка нужных расширений
RUN apt-get update && apt-get install -y \
    libpq-dev unzip curl git zip libzip-dev \
    && docker-php-ext-install pdo pdo_pgsql

# Установка Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Копирование проекта
COPY . /var/www/html
WORKDIR /var/www/html

# Копирование собранного фронта
COPY --from=build /app/public/js /var/www/html/public/js
COPY --from=build /app/mix-manifest.json /var/www/html/public/mix-manifest.json

# Настройка Apache
RUN a2enmod rewrite && \
    sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Права
RUN chmod -R 775 storage bootstrap/cache

# Установка PHP-зависимостей
RUN composer install --no-dev --optimize-autoloader

# Копирование и настройка entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]