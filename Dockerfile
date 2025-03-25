FROM php:8.2-apache

# Установка системных зависимостей и Node.js
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    zip \
    libpq-dev \
    libzip-dev \
    nodejs \
    npm \
    && docker-php-ext-install pdo_pgsql zip

# Установка Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Копирование проекта
COPY . /var/www/html
WORKDIR /var/www/html

# Права на storage и bootstrap/cache
RUN chown -R www-data:www-data storage bootstrap/cache

# Включаем mod_rewrite
RUN a2enmod rewrite

# Меняем DocumentRoot на /public
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Установка PHP и JS-зависимостей
RUN composer install --no-dev --optimize-autoloader \
    && npm install \
    && npm run production

# Копируем и запускаем стартовый скрипт
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80
CMD ["/start.sh"]