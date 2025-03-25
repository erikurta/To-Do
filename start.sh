#!/bin/bash

# Очистка и генерация ключа
php artisan config:clear
php artisan key:generate

# Применение миграций
php artisan migrate --force

# Запуск Apache
exec apache2-foreground