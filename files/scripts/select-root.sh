#!/usr/bin/env bash
set -euo pipefail

source lib.sh

LOG_PREFIX=btrfs
RETIRED_ROOT=
ROLLBACK_TARGET=

snapshot_from_cmdline() {
    local cmdline=${1:-/proc/cmdline}
    local name
    local word
    local -a words=()

    IFS=$' \t' read -r -a words <"$cmdline" 2>/dev/null || true

    for word in "${words[@]}"; do
        case $word in
            "$ROOT_TOKEN"=?*)
                name=${word#"$ROOT_TOKEN="}

                case $name in
                    *[!A-Za-z0-9_.:-]*) return 0 ;;
                esac

                printf '%s\n' "$name"
                return 0
                ;;
        esac
    done

    return 0
}

snapshot_target() {
    local name
    local target

    name=$(snapshot_from_cmdline)

    if [[ -z $name ]]; then
        return 0
    fi

    target=$OLD_ROOTS/$name

    if [[ ! -d $target ]]; then
        log "unknown root snapshot: $name"
        return 0
    fi

    printf '%s\n' "$target"
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
    ROLLBACK_TARGET=$(snapshot_target)

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

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
    main
fi
