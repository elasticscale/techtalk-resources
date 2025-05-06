# 🐳 Level 1 Dockerization Exercise: PHP App + Dotenv

This is a **basic no-framework PHP app** with real-world complexity:

- Uses Composer
- Loads ENV from file or docker environment using `vlucas/phpdotenv`
- Designed to teach Dockerization from scratch

---

## 🎯 Your Mission

Dockerize this app so it:

- Runs in a container
- Exposes a working web server on port 8080
- It should load the environment through Docker
- Responds to `/` and `/health.php`
- Passes a `HEALTHCHECK`

---

## 🔧 Getting Started (Locally)

You can test it without Docker:

```bash
composer install
php -S localhost:8080 -t app