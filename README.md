# infra-monitoring-project

## Проверка API

Передайте URL первым аргументом. HTTP-код `200` считается успехом: скрипт возвращает `0`. При другом коде ответа он возвращает `1`.

```bash
bash check_api.sh https://httpbin.org/status/200
bash check_api.sh https://httpbin.org/status/404
```

## Анализ логов

Скрипт создаёт файл `access.log` из 300 записей и выводит общее количество запросов, три наиболее частых IP-адреса и количество ответов с кодами 4xx и 5xx.

```bash
bash analyze_logs.sh
```

## Запуск контейнеров

Из корня проекта выполните:

```bash
docker compose up -d
docker compose ps
curl http://localhost:80
```

Ожидаемый ответ: `Monitoring Service Active`.

Чтобы остановить контейнеры, выполните:

```bash
docker compose down
```

Сервисы подключены к внутренней сети `monitoring`. Nginx принимает запросы на порту 80 и передаёт их сервису `api` на порту 8080.

## GitHub Actions

Workflow `.github/workflows/ci.yml` запускается при создании Pull Request в `main`. Он проверяет синтаксис Bash-скриптов и запускает проверку тестового URL.

## Безопасная передача проекта на сервер по SSH/SCP

Создайте SSH-ключ, если у вас его ещё нет:

```bash
ssh-keygen -t ed25519 -C "student@example.com"
```

Скопируйте публичный ключ на сервер:

```bash
ssh-copy-id USER@SERVER_HOST
```

Проверьте подключение:

```bash
ssh USER@SERVER_HOST
```

Из каталога проекта создайте архив, передайте его на сервер и распакуйте:

```bash
tar -czf infra-monitoring-project.tar.gz --exclude=.git --exclude='*.log' .
scp infra-monitoring-project.tar.gz USER@SERVER_HOST:~/
ssh USER@SERVER_HOST "mkdir -p ~/infra-monitoring-project && tar -xzf ~/infra-monitoring-project.tar.gz -C ~/infra-monitoring-project"
```

Замените `USER` и `SERVER_HOST` на имя пользователя и адрес сервера. На сервер копируется только публичный SSH-ключ; закрытый ключ никому не передавайте.
