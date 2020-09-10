#!/bin/bash

# script to send a deploy notification to a Telegram channel
CURRENT_DATE=$(date "+%F %T")
CHAT_ID="<CHAT ID>"
BOT_TOKEN="<BOT TOKEN>"
if [ -z $RENEWED_DOMAINS ]; then
  RENEWED_DOMAINS="<none>"
fi
MSG_TEXT="${CURRENT_DATE} - Let's Encrypt certificate(s) updated for: "
MSG_TEXT="${MSG_TEXT} '${RENEWED_DOMAINS}'"

curl -s -X POST \
  --data chat_id="${CHAT_ID}" \
  --data text="${MSG_TEXT}" \
  --url https://api.telegram.org/bot${BOT_TOKEN}/sendMessage \
  --output /dev/null

