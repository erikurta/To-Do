# Stage 1 — Build frontend
FROM node:18 as build

WORKDIR /app

# Копируем package.json и package-lock.json
COPY package*.json ./

# Устанавливаем зависимости и собираем проект
RUN npm install && npm run prod

# Stage 2 — PHP + Apache
FROM php:8.2-apache

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    libpq-dev \
    unzip \
    git \
    curl \
    libzip-dev \
    zip \
    && docker-php-ext-install pdo pdo_pgsql

# Включаем модуль Apache mod_rewrite
RUN a2enmod rewrite

# Настройка DocumentRoot
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Установка Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Копируем Laravel-проект
COPY . /var/www/html
WORKDIR /var/www/html

# Устанавливаем PHP-зависимости
RUN composer install --no-dev --optimize-autoloader

# Копируем собранные ассеты из первого stage
COPY --from=build /app/public/js /var/www/html/public/js

# Назначаем нужные права
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Копируем скрипт запуска
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Указываем CMD (запускаем Apache после artisan команд)
CMD ["/entrypoint.sh"]