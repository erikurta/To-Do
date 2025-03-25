# Используем PHP с Apache
FROM php:8.2-apache

# Устанавливаем необходимые расширения PHP
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    curl \
    git \
    npm \
    nodejs \
    && docker-php-ext-install pdo pdo_mysql

# Устанавливаем Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Копируем код проекта
COPY . /var/www/html

# Рабочая директория
WORKDIR /var/www/html

# Включаем модуль Apache для работы с .htaccess
RUN a2enmod rewrite

# Указываем Laravel, где находится public директория
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Устанавливаем права доступа
RUN chown -R www-data:www-data \
    /var/www/html/storage \
    /var/www/html/bootstrap/cache

# Устанавливаем зависимости PHP
RUN composer install --optimize-autoloader --no-dev

# Устанавливаем зависимости Node.js и компилируем фронт
RUN npm install && npm run production

# Генерируем ключ Laravel автоматически
RUN php artisan key:generate

# Экспонируем порт
EXPOSE 80

# Стартуем Apache в foreground-режиме
CMD ["apache2-foreground"]