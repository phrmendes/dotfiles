#!/bin/bash

send_notification() {
    local title="$1"
    local message="$2"
    local priority="$3"

    curl -s --max-time 10 "$GOTIFY_URL?token=$GOTIFY_TRANSMISSION_TOKEN" \
        -F "title=$title" \
        -F "message=$message" \
        -F "priority=$priority" >/dev/null 2>&1
}

if [ "$GOTIFY_URL" = "" ] || [ "$GOTIFY_TRANSMISSION_TOKEN" = "" ]; then
    echo "$(date): transmission-gotify-notification: Missing GOTIFY_URL or GOTIFY_TRANSMISSION_TOKEN" >> /tmp/transmission-script.log
    exit 1
fi

TORRENT_NAME="${TR_TORRENT_NAME:-Unknown}"
TORRENT_DIR="${TR_TORRENT_DIR:-Unknown}"
TORRENT_SIZE=""

if command -v du >/dev/null 2>&1 && [ "$TR_TORRENT_DIR" != "" ] && [ -d "$TR_TORRENT_DIR" ]; then
    TORRENT_SIZE=$(du -sh "$TR_TORRENT_DIR" 2>/dev/null | cut -f1)
    if [ "$TORRENT_SIZE" != "" ]; then
        TORRENT_SIZE=" (Size: $TORRENT_SIZE)"
    fi
fi

MESSAGE="Torrent: $TORRENT_NAME$TORRENT_SIZE
Downloaded to: $TORRENT_DIR
Completed: $(date)"

send_notification "📥 Download Complete" "$MESSAGE" "5"

echo "$(date): Notification sent for torrent: $TORRENT_NAME" >> /tmp/transmission-script.log

exit 0
