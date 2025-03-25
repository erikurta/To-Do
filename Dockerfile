FROM php:8.2-apache

# Установка нужных расширений
RUN docker-php-ext-install pdo pdo_mysql

# Установка Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Копирование проекта
COPY . /var/www/html
WORKDIR /var/www/html

# Включаем mod_rewrite для Laravel
RUN a2enmod rewrite

# Настройка DocumentRoot
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Разрешаем права для storage и cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Установка зависимостей PHP и JS
RUN composer install --no-dev --optimize-autoloader && \
    npm install && \
    npm run prod

# Генерация ключа приложения
RUN php artisan key:generate && \
    php artisan migrate --force

EXPOSE 80
CMD ["apache2-foreground"]