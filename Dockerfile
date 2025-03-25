# Сборочный этап для frontend (если используешь Laravel Mix)
FROM node:18 as build

# Установка зависимостей и сборка фронта
WORKDIR /app
COPY package*.json webpack.mix.js ./
COPY resources ./resources
RUN npm install && npm run prod

# Основной этап — Laravel + Apache
FROM php:8.2-apache

# Установка необходимых расширений
RUN apt-get update && apt-get install -y \
    libpq-dev unzip curl git zip && \
    docker-php-ext-install pdo pdo_pgsql

# Установка Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Копирование проекта
COPY . /var/www/html
WORKDIR /var/www/html

# Включаем mod_rewrite
RUN a2enmod rewrite

# Меняем DocumentRoot
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Настройка прав доступа
RUN chmod -R 775 storage bootstrap/cache && \
    chown -R www-data:www-data storage bootstrap/cache

# Копирование frontend сборки
COPY --from=build /app/public/js /var/www/html/public/js

# Копирование стартового скрипта
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Указываем CMD
EXPOSE 80
CMD ["/entrypoint.sh"]