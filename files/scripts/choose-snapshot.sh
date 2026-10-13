#!/usr/bin/env bash
set -euo pipefail

source lib.sh

LOG_PREFIX=btrfs
ROLLBACK_TIMEOUT=${ROLLBACK_TIMEOUT:-5}
RETIRED_ROOT=
ROLLBACK_TARGET=

choose_snapshot() {
    local snapshots=()
    local menu=()
    local index
    local choice

    mapfile -t snapshots < <(list_old_roots)

    if ((${#snapshots[@]} == 0)); then
        return 0
    fi

    menu=(0 "fresh root")

    for index in "${!snapshots[@]}"; do
        menu+=("$((index + 1))" "${snapshots[$index]##*/}")
    done

    choice=$(TERM=${TERM:-linux} dialog \
        --backtitle "NixOS" \
        --title "Root snapshot" \
        --no-shadow --aspect 12 \
        --ok-button "Boot" --cancel-button "Fresh root" \
        --default-item 0 --timeout "$ROLLBACK_TIMEOUT" \
        --menu "Choose the root subvolume to boot" 0 0 0 "${menu[@]}" \
        2>&1 1>/dev/console </dev/console) || true

    if [[ ! $choice =~ ^[0-9]+$ ]]; then
        return 0
    fi

    if ((choice < 1 || choice > ${#snapshots[@]})); then
        return 0
    fi

    ROLLBACK_TARGET=${snapshots[$((choice - 1))]}

    return 0
}

retire_root() {
    local root_mtime
    local root_created
    local unique_suffix
    local target

    if ! is_subvolume "$ROOT_SUBVOL"; then
        return 0
    fi

    mkdir -p "$OLD_ROOTS"

    root_mtime=$(stat -c %Y "$ROOT_SUBVOL" 2>/dev/null) || return 0
    root_created=$(date --date="@$root_mtime" "+%Y-%m-%-d_%H:%M:%S" 2>/dev/null) || return 0
    unique_suffix=$(od -An -N4 -tx1 /dev/urandom 2>/dev/null | tr -d ' ')

    target=$OLD_ROOTS/${root_created}_$unique_suffix

    if mv "$ROOT_SUBVOL" "$target" 2>/dev/null; then
        RETIRED_ROOT=$target
        log "retired root to ${target##*/}"
    fi

    return 0
}

boot_snapshot() {
    local target=$ROLLBACK_TARGET

    retire_root

    if [[ -z $RETIRED_ROOT ]]; then
        log "could not retire the current root; keeping it"
        return 0
    fi

    if mv "$target" "$ROOT_SUBVOL" 2>/dev/null; then
        log "booting snapshot ${target##*/}"
        return 0
    fi

    log "failed to promote ${target##*/}; restoring the previous root"

    if ! mv "$RETIRED_ROOT" "$ROOT_SUBVOL" 2>/dev/null; then
        log "failed to restore the previous root"
    fi

    return 0
}

ensure_root() {
    if is_subvolume "$ROOT_SUBVOL"; then
        return 0
    fi

    if btrfs subvolume create "$ROOT_SUBVOL" >/dev/null 2>&1; then
        return 0
    fi

    log "failed to create root subvolume"

    if [[ -n $RETIRED_ROOT ]]; then
        if mv "$RETIRED_ROOT" "$ROOT_SUBVOL" 2>/dev/null; then
            log "restored the previous root"
            return 0
        fi
    fi

    return 1
}

main() {
    trap umount_btrfs EXIT

    mount_btrfs
    choose_snapshot

    if [[ -n $ROLLBACK_TARGET ]]; then
        boot_snapshot
    else
        retire_root
    fi

    if ! ensure_root; then
        log "fatal: no root subvolume and no previous root to restore"
        exit 1
    fi
}

main
