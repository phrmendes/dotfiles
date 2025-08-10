#!/bin/bash

EVENTNAME=$DUPLICATI__EVENTNAME
OPERATIONNAME=$DUPLICATI__OPERATIONNAME
REMOTEURL=$DUPLICATI__REMOTEURL
LOCALPATH=$DUPLICATI__LOCALPATH
PARSED_RESULT=$DUPLICATI__PARSED_RESULT

send_notification() {
    local title="$1"
    local priority="$2"
    local status="$3"
    local error_details="$4"

    local clean_url="${REMOTEURL%%\?*}"

    local message

    case "$status" in
        "success")
            message="Backup completed successfully - Target: $clean_url - Source: $LOCALPATH"
            ;;
        "warning")
            message="Backup completed with warnings - Target: $clean_url - Source: $LOCALPATH - Check logs for details"
            ;;
        "error")
            message="Backup failed - Target: $clean_url - Source: $LOCALPATH - Error: $error_details"
            ;;
        "unknown")
            message="Backup completed with unknown status: $PARSED_RESULT - Target: $clean_url - Source: $LOCALPATH"
            ;;
    esac

    curl -s --max-time 10 "$GOTIFY_URL/message?token=$GOTIFY_DUPLICATI_TOKEN" \
        -F "title=$title" \
        -F "message=$message" \
        -F "priority=$priority" >/dev/null 2>&1
}

if [ "$EVENTNAME" == "AFTER" ] && [ "$OPERATIONNAME" == "Backup" ]; then
    case "$PARSED_RESULT" in
        "Success")
            send_notification "✅ Success" "2" "success"
            ;;
        "Warning")
            send_notification "⚠️ Warning" "5" "warning"
            ;;
        "Error"|"Fatal")
            ERROR_DETAILS=""
            if [ -f "$DUPLICATI__RESULTFILE" ] && [ -s "$DUPLICATI__RESULTFILE" ]; then
                ERROR_DETAILS=$(tail -20 "$DUPLICATI__RESULTFILE" 2>/dev/null | tr '\n' ' ')
            fi

            send_notification "❌ Failed" "8" "error" "$ERROR_DETAILS"
            ;;
        *)
            send_notification "❓ Unknown" "5" "unknown"
            ;;
    esac
fi

exit 0
