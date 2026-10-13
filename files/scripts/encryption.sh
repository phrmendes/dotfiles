#!/usr/bin/env bash
set -euo pipefail

source lib.sh

LOG_PREFIX=encryption
LUKS_DEVICE=${LUKS_DEVICE:-/dev/disk/by-partlabel/disk-main-luks}
ESP_DEVICE=${ESP_DEVICE:-/dev/disk/by-partlabel/disk-main-ESP}
ESP_MNT=${ESP_MNT:-/run/esp}
STAMP=$ESP_MNT/credential.stamp
TTL=${TTL:-43200}
PASS_FILE=/run/credential.pass

mount_esp() {
    mount_filesystem "$ESP_DEVICE" "$ESP_MNT"
}

umount_esp() {
    umount_filesystem "$ESP_MNT"
}

has_tpm_slot() {
    systemd-cryptenroll "$LUKS_DEVICE" 2>/dev/null | grep -qi tpm2
}

wait_for_tpm() {
    local _attempt

    for _attempt in {1..50}; do
        if [[ -e /dev/tpmrm0 ]] || [[ -e /dev/tpm0 ]]; then
            return 0
        fi

        sleep 0.1
    done

    return 1
}

is_fresh() {
    local stamp
    local now

    if [[ ! -f $STAMP ]]; then
        return 1
    fi

    stamp=$(<"$STAMP")

    if [[ ! $stamp =~ ^[0-9]+$ ]]; then
        return 1
    fi

    now=$(date +%s)

    if ((stamp > now)); then
        return 1
    fi

    if ((now - stamp >= TTL)); then
        return 1
    fi

    return 0
}

wipe() {
    if ! systemd-cryptenroll --wipe-slot=tpm2 "$LUKS_DEVICE" >/dev/null 2>&1; then
        log "failed to wipe the TPM keyslot"
    fi

    rm -f "$STAMP"

    return 0
}

enroll() {
    local passphrase

    while true; do
        passphrase=$(TERM=${TERM:-linux} dialog \
            --backtitle "NixOS" \
            --title " Unlock encrypted root " \
            --no-shadow --aspect 12 --cr-wrap \
            --insecure \
            --ok-button "Unlock" --cancel-button "Skip" \
            --passwordbox "Enter the passphrase for the root disk.\n\nThe cached key expired after 12 hours." \
            0 0 \
            2>&1 1>/dev/console </dev/console) || return 1

        if [[ -z $passphrase ]]; then
            continue
        fi

        printf '%s' "$passphrase" >"$PASS_FILE"
        chmod 600 "$PASS_FILE"

        dialog --infobox "Setting up TPM unlock for the next 12 hours..." 5 64 \
            2>&1 1>/dev/console </dev/console

        if ! wait_for_tpm; then
            log "TPM device not found"
        fi

        if systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 \
            --unlock-key-file="$PASS_FILE" "$LUKS_DEVICE" >/dev/null 2>&1; then
            rm -f "$PASS_FILE"
            date +%s >"$STAMP"
            sync
            return 0
        fi

        rm -f "$PASS_FILE"

        dialog --msgbox "Wrong passphrase. Try again." 5 40 \
            2>&1 1>/dev/console </dev/console
    done
}

ensure() {
    trap umount_esp EXIT

    mount_esp

    if has_tpm_slot; then
        if is_fresh; then
            log "cache is fresh; skipping the passphrase"
            return 0
        fi

        wipe
    fi

    if ! enroll; then
        log "no TPM enrollment; falling back to the console prompt"
    fi
}

expire() {
    trap umount_esp EXIT

    mount_esp

    if ! has_tpm_slot; then
        rm -f "$STAMP"
        return 0
    fi

    if is_fresh; then
        return 0
    fi

    log "cache expired; wiping the keyslot"

    wipe
}

command=${1:-}

if [[ $command == ensure ]]; then
    ensure
elif [[ $command == expire ]]; then
    expire
else
    echo "usage: $(basename "$0") {ensure|expire}" >&2
    exit 2
fi
