#!/usr/bin/env bash

set -euo pipefail

GOTIFY_URL="https://gotify.local.ohlongjohnson.tech"
GOTIFY_SYSTEM_TOKEN="$(cat /run/agenix/gotify-server-upgrade-token)"
FLAKE_PATH="/home/phrmendes/dotfiles"
LOG_FILE="/var/log/nixos-auto-upgrade.log"
HOSTNAME="$(hostname)"

send_notification() {
    local title="$1"
    local message="$2"
    local priority="${3:-5}"

    if [[ -n "$GOTIFY_URL" && -n "$GOTIFY_SYSTEM_TOKEN" ]]; then
        curl -s --max-time 10 \
            -X POST "$GOTIFY_URL/message?token=$GOTIFY_SYSTEM_TOKEN" \
            -H "Content-Type: application/json" \
            -d "{
                \"title\": \"$title\",
                \"message\": \"$message\",
                \"priority\": $priority
            }" || true
    fi
}

log_msg() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $*" | tee -a "$LOG_FILE"
}

log_msg "Starting NixOS auto-upgrade on $HOSTNAME"
send_notification "🔄 System Upgrade Started" "Auto-upgrade process initiated on $HOSTNAME" 5

cd "$FLAKE_PATH"

if git pull 2>&1 | tee -a "$LOG_FILE"; then
    log_msg "Git pull completed successfully"
else
    log_msg "Failed to pull git changes"
    send_notification "❌ Upgrade Failed" "Failed to pull git changes on $HOSTNAME" 8
    exit 1
fi

if nixos-rebuild switch --flake "$FLAKE_PATH#$HOSTNAME" 2>&1 | tee -a "$LOG_FILE"; then
    log_msg "NixOS rebuild completed successfully"
    send_notification "✅ System Upgrade Complete" "NixOS auto-upgrade completed successfully on $HOSTNAME" 5

    systemctl reload docker-compose.service || true
    log_msg "Docker Compose services reloaded"
else
    log_msg "NixOS rebuild failed"
    send_notification "❌ Upgrade Failed" "NixOS rebuild failed on $HOSTNAME. Check logs for details." 9
    exit 1
fi

log_msg "Auto-upgrade process completed"
