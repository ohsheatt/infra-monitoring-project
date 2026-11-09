# infra-monitoring-project

Учебный проект для мониторинга доступности API, анализа журналов и запуска API с обратным прокси в Docker Compose.

## Требования

- Bash
- `curl`
- Docker Desktop с Docker Compose

## Проверка API

Передайте URL первым аргументом. HTTP-код `200` считается успехом; при успехе скрипт возвращает `0`, иначе — `1`.

```bash
bash check_api.sh https://httpbin.org/status/200
bash check_api.sh https://httpbin.org/status/404
```

## Анализ логов

Скрипт создаёт тестовый `access.log` из 300 записей, затем выводит общее количество запросов, три наиболее частых IP и количество ответов 4xx/5xx. Можно передать другой путь к файлу:

```bash
bash analyze_logs.sh
bash analyze_logs.sh work/access.log
```

## Запуск контейнеров

Из корня проекта выполните:

```bash
docker compose up -d
docker compose ps
curl http://localhost:80
```

Ожидаемый текст ответа: `Monitoring Service Active`.

Остановка:

```bash
docker compose down
```

Сервисы подключены к внутренней сети `monitoring`. Nginx принимает запросы на порту 80 и передаёт их сервису `api` на порту 8080.

## GitHub Actions

Workflow `.github/workflows/ci.yml` запускается при создании Pull Request в `main`. Он проверяет синтаксис Bash-скриптов и выполняет проверку тестового URL.

## Безопасная передача проекта на сервер по SSH/SCP

Сначала создайте SSH-ключ (если у вас его ещё нет):

```bash
ssh-keygen -t ed25519 -C "student@example.com"
```

Добавьте публичный ключ на сервер:

```bash
ssh-copy-id USER@SERVER_HOST
```

Подключитесь и проверьте соединение:

```bash
ssh USER@SERVER_HOST
```

Из каталога проекта передайте архив на сервер и распакуйте его:

```bash
tar -czf infra-monitoring-project.tar.gz --exclude=.git --exclude='*.log' .
scp infra-monitoring-project.tar.gz USER@SERVER_HOST:~/
ssh USER@SERVER_HOST "mkdir -p ~/infra-monitoring-project && tar -xzf ~/infra-monitoring-project.tar.gz -C ~/infra-monitoring-project"
```

Здесь `USER` и `SERVER_HOST` заменяются именем пользователя и адресом вашего сервера. Не передавайте закрытый SSH-ключ; на сервер копируется только публичный ключ.
