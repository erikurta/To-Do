#!/bin/bash

# Выдаём права
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Кэш очищаем на всякий случай
php artisan config:clear

# Запускаем Apache
apache2-foreground