#!/bin/bash
echo ">> Menunggu aplikasi siap..."

MAX_RETRY=15
COUNT=0

until [ $COUNT -ge $MAX_RETRY ]; do
  HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9090/spring-boot-testing/api/v1/categories)
  if [ "$HTTP_STATUS" -ge 200 ] && [ "$HTTP_STATUS" -lt 500 ]; then
    echo ">> OK - Aplikasi merespons dengan status $HTTP_STATUS"
    exit 0
  fi
  COUNT=$((COUNT+1))
  echo ">> Percobaan $COUNT/$MAX_RETRY - status: $HTTP_STATUS, tunggu 10 detik..."
  sleep 10
done

echo ">> GAGAL - Aplikasi tidak merespons setelah $((MAX_RETRY*10)) detik"
exit 1
