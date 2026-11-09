#!/usr/bin/env bash

if [[ $# -ne 1 || -z "$1" ]]; then
  echo "Использование: $0 <URL>" >&2
  exit 1
fi

url="$1"
http_code=$(curl --silent --show-error --output /dev/null --write-out '%{http_code}' --max-time 10 "$url" 2>/dev/null) || http_code="${http_code:-000}"

if [[ "$http_code" == "200" ]]; then
  echo "API доступен"
  exit 0
fi

if [[ -z "$http_code" ]]; then
  http_code="000"
fi
echo "API недоступен, код ответа: $http_code"
exit 1
