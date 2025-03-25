FROM php:8.2-apache

# Установка расширений
RUN apt-get update && apt-get install -y \
    libpq-dev unzip curl git zip libzip-dev \
    && docker-php-ext-install pdo pdo_pgsql

# Установка Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Копирование проекта
COPY . /var/www/html
WORKDIR /var/www/html

# Настройка Apache
RUN a2enmod rewrite && \
    sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Права
RUN chmod -R 775 storage bootstrap/cache

# Установка зависимостей PHP
RUN composer install --no-dev --optimize-autoloader

# Копируем скрипт запуска
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]