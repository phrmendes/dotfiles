#!/bin/bash

send_notification() {
    local title="$1"
    local message="$2"
    local priority="$3"

    curl -s --max-time 10 "$GOTIFY_URL/message?token=$GOTIFY_SABNZBD_TOKEN" \
        -F "title=$title" \
        -F "message=$message" \
        -F "priority=$priority" >/dev/null 2>&1
}

if [ "$GOTIFY_URL" = "" ] || [ "$GOTIFY_SABNZBD_TOKEN" = "" ]; then
    exit 1
fi

notification_type="$1"
notification_title="$2"
notification_message="$3"

if [ "$notification_type" = "" ] || [ "$notification_title" = "" ] || [ "$notification_message" = "" ]; then
    exit 1
fi

case "$notification_type" in
    "startup")
        priority=2
        title="🚀 $notification_title"
        ;;
    "download")
        priority=2
        title="📥 $notification_title"
        ;;
    "pp")
        priority=2
        title="⚙️ $notification_title"
        ;;
    "complete")
        priority=5
        title="✅ $notification_title"
        ;;
    "queue_done")
        priority=5
        title="🏁 $notification_title"
        ;;
    "failed")
        priority=8
        title="❌ $notification_title"
        ;;
    "error")
        priority=8
        title="🚨 $notification_title"
        ;;
    "disk_full")
        priority=8
        title="💾 $notification_title"
        ;;
    "warning")
        priority=6
        title="⚠️ $notification_title"
        ;;
    "new_login")
        priority=4
        title="👤 $notification_title"
        ;;
    "other")
        priority=2
        title="ℹ️ $notification_title"
        ;;
    *)
        priority=2
        title="$notification_title"
        ;;
esac

send_notification "$title" "$notification_message" "$priority"

exit 0
