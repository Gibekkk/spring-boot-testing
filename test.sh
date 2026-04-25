#!/bin/bash
echo ">> Menunggu aplikasi siap..."
sleep 20

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9090/spring-boot-testing/api/v1/categories)

if [ "$HTTP_STATUS" -ge 200 ] && [ "$HTTP_STATUS" -lt 500 ]; then
  echo ">> OK - Aplikasi merespons dengan status $HTTP_STATUS"
  exit 0
else
  echo ">> GAGAL - Aplikasi tidak merespons (status: $HTTP_STATUS)"
  exit 1
fi
