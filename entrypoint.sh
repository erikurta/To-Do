#!/bin/bash

php artisan config:clear
php artisan key:generate

php artisan migrate --force || true

exec apache2-foreground