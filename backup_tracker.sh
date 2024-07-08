#!/bin/bash

kctl transfers dump

BACKUP_PATH="/var/lib/kctl-transfers"

LATEST_DUMP=$(ls -t $BACKUP_PATH | head -n 1)

DUMP_FILE="$BACKUP_PATH/$LATEST_DUMP"

echo "Latest dump file created: $DUMP_FILE"

BOT_TOKEN="bot_token"
CHAT_ID="chat_id"
MESSAGE_TEXT="New backup file: $LATEST_DUMP"

curl -F chat_id="$CHAT_ID" -F document=@"$DUMP_FILE" -F caption="$MESSAGE_TEXT" "https://api.telegram.org/bot$BOT_TOKEN/sendDocument"

