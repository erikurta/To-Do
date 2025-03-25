#!/bin/bash

# Генерим APP_KEY, если не установлен
if ! grep -q "^APP_KEY=base64:" .env; then
  echo "⚙️ Генерируем ключ..."
  php artisan key:generate --force
fi

# Даем права на storage и bootstrap/cache
chmod -R 775 storage bootstrap/cache

# Запускаем Apache
echo "🚀 Запуск Apache..."
exec apache2-foreground