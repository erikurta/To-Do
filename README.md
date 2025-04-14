# 📝 To-Do App

Простое приложение на Laravel + Vue 2 для управления задачами.  
Развёрнуто через Docker и деплоится на Render с PostgreSQL.

---

## 🚀 Live Demo  
👉 [to-do-biay.onrender.com](https://to-do-biay.onrender.com)

---

## 📦 Стек технологий

- **Backend:** Laravel 10
- **Frontend:** Vue 2 + Vue Router + Laravel Mix
- **БД:** PostgreSQL (Render Cloud Database)
- **Docker:** Apache + PHP 8.2
- **Хостинг:** [Render.com](https://render.com)

---

## ⚙️ Установка (локально)

```bash
git clone https://github.com/erikurta/To-Do.git
cd To-Do

# Установка PHP зависимостей
composer install

# Установка JS зависимостей
npm install
npm run dev

# Создай .env
cp .env.example .env

# Генерация ключа
php artisan key:generate

# Настройка БД и миграции
php artisan migrate
```

---

## 🐳 Docker-деплой (на Render)

### 1. Собери фронтенд локально

```bash
npm run prod
```

### 2. Добавь собранные файлы в git

```bash
git add -f public/js/app.js public/mix-manifest.json
git commit -m "Добавил собранный фронт"
git push
```

### 3. Render

- Создай PostgreSQL базу на Render → возьми `DB_HOST`, `DB_PORT`, `DB_USERNAME`, `DB_PASSWORD`
- Создай Web Service (Docker)
- В `.env` или через Environment Variables укажи параметры БД
- Пропиши переменные в Render → вкладка **Environment**
- При первом запуске перейди по `/init`, чтобы выполнить миграции:

```
https://your-app.onrender.com/init
```

---

## 🛠 Полезные команды

```bash
# Пересобрать фронт
npm run dev      # или npm run prod

# Очистить кэш
php artisan config:clear
```

---

## 💡 Особенности

- Render **не поддерживает Shell** на Free-плане → миграции запускаются через маршрут `/init`
- Используется `entrypoint.sh` для запуска Apache
- `storage` и `bootstrap/cache` — автоматически получают права внутри контейнера

---

## 🧾 Лицензия

Проект доступен под лицензией [MIT](LICENSE).