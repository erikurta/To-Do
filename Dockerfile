FROM node:18 as build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run prod


FROM php:8.2-apache

# Установка нужных пакетов и расширений PHP
RUN apt-get update && apt-get install -y \
    libpq-dev \
    unzip \
    git \
    && docker-php-ext-install pdo pdo_pgsql

# Установка Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Копирование проекта
COPY . /var/www/html
WORKDIR /var/www/html

# Копирование собранного фронта
COPY --from=build /app/public/js /var/www/html/public/js
# Apache конфиг
RUN a2enmod rewrite \
 && sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Разрешения
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Установка зависимостей PHP
RUN composer install --no-dev --optimize-autoloader

# Генерация ключа и миграции
RUN php artisan config:clear && \
    if [ ! -f .env ]; then cp .env.example .env; fi && \
    php artisan key:generate && \
    php artisan migrate --force || true

EXPOSE 80

CMD ["apache2-foreground"]