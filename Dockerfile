FROM php:8.2-apache

# Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    zip \
    libzip-dev \
    nodejs \
    npm \
    && docker-php-ext-install pdo pdo_mysql

# Установка Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Копируем проект в контейнер
COPY . /var/www/html

# Устанавливаем рабочую директорию
WORKDIR /var/www/html

# Включаем mod_rewrite
RUN a2enmod rewrite

# Меняем DocumentRoot на /public
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Назначаем права для Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Устанавливаем зависимости PHP и Node
RUN composer install --no-dev --optimize-autoloader
RUN php artisan key:generate
RUN npm install
RUN npm run prod

# Открываем порт 80
EXPOSE 80

# Запуск Apache
CMD ["apache2-foreground"]