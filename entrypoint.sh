#!/bin/bash

php artisan config:clear
php artisan migrate --force || true

exec apache2-foreground