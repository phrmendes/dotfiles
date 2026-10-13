#!/usr/bin/env bash

export BTRFS_DEVICE=${BTRFS_DEVICE:-/dev/mapper/crypted}
export BTRFS_MNT=${BTRFS_MNT:-/btrfs_tmp}
export ROOT_SUBVOL=$BTRFS_MNT/root
export OLD_ROOTS=$BTRFS_MNT/old_roots
export KEEP_OLD_ROOTS=${KEEP_OLD_ROOTS:-5}

log() {
    printf '%s: %s\n' "${LOG_PREFIX:-initrd}" "$*" >&2
}

is_mounted() {
    mountpoint --quiet "$1"
}

mount_filesystem() {
    local device=$1
    local mountpoint=$2

    mkdir -p "$mountpoint"

    if is_mounted "$mountpoint"; then
        return 0
    fi

    mount "$device" "$mountpoint"
}

umount_filesystem() {
    local mountpoint=$1

    if ! is_mounted "$mountpoint"; then
        return 0
    fi

    if umount "$mountpoint" 2>/dev/null; then
        return 0
    fi

    umount -l "$mountpoint" 2>/dev/null

    return 0
}

wait_for_path() {
    local path=$1
    local _attempt

    for _attempt in {1..50}; do
        if [[ -e $path ]]; then
            return 0
        fi

        sleep 0.1
    done

    return 1
}

is_subvolume() {
    local path=$1

    btrfs subvolume show "$path" >/dev/null 2>&1
}

delete_subvolume() {
    local subvolume=$1
    local line
    local child

    if ! is_subvolume "$subvolume"; then
        return 0
    fi

    while IFS= read -r line; do
        child=${line#* path }

        if [[ -n $child ]]; then
            delete_subvolume "$BTRFS_MNT/$child"
        fi
    done < <(btrfs subvolume list -o "$subvolume" 2>/dev/null)

    if ! btrfs subvolume delete "$subvolume" >/dev/null 2>&1; then
        log "warning: could not delete $subvolume"
    fi

    return 0
}

list_old_roots() {
    find "$OLD_ROOTS" -maxdepth 1 -mindepth 1 -printf '%T@\t%p\n' 2>/dev/null |
        sort -rn |
        cut -f 2-
}

mount_btrfs() {
    if ! wait_for_path "$BTRFS_DEVICE"; then
        log "warning: $BTRFS_DEVICE not present yet"
    fi

    mount_filesystem "$BTRFS_DEVICE" "$BTRFS_MNT"
}

umount_btrfs() {
    umount_filesystem "$BTRFS_MNT"
}
