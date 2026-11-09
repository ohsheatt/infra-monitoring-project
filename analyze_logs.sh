#!/usr/bin/env bash
set -euo pipefail

log_file="${1:-access.log}"

# Create at least 300 sample access records for this exercise.
: > "$log_file"
for i in $(seq 1 300); do
  case $((i % 5)) in
    0) ip="192.168.1.10"; status=200; method="GET"; path="/api/users" ;;
    1) ip="10.0.0.5"; status=401; method="POST"; path="/api/login" ;;
    2) ip="192.168.1.20"; status=200; method="GET"; path="/api/status" ;;
    3) ip="172.16.0.8"; status=500; method="GET"; path="/api/data" ;;
    4) ip="192.168.1.10"; status=404; method="GET"; path="/missing" ;;
  esac
  printf '%s - - [15/Aug/2026:10:%02d:%02d] "%s %s HTTP/1.1" %s\n' \
    "$ip" "$((i / 60))" "$((i % 60))" "$method" "$path" "$status" >> "$log_file"
done

echo "Файл логов: $log_file"
echo "Общее количество запросов: $(grep -Ec '^[0-9]{1,3}(\.[0-9]{1,3}){3} ' "$log_file")"
echo "Топ-3 IP-адреса по числу запросов:"
grep -Eo '^[0-9]{1,3}(\.[0-9]{1,3}){3}' "$log_file" | sort | uniq -c | sort -nr | head -3 | awk '{print $2 ": " $1}'
echo "Количество запросов с кодами 4xx: $(awk '$NF ~ /^4[0-9][0-9]$/ {count++} END {print count+0}' "$log_file")"
echo "Количество запросов с кодами 5xx: $(awk '$NF ~ /^5[0-9][0-9]$/ {count++} END {print count+0}' "$log_file")"
