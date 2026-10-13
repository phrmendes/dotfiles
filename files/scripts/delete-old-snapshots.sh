#!/usr/bin/env bash
set -euo pipefail

source lib.sh

LOG_PREFIX=btrfs

prune_old_roots() {
    local old_root
    local roots_to_delete

    if [[ ! -d $OLD_ROOTS ]]; then
        return 0
    fi

    roots_to_delete=$(list_old_roots | tail -n +$((KEEP_OLD_ROOTS + 1)))

    if [[ -z $roots_to_delete ]]; then
        return 0
    fi

    while IFS= read -r old_root; do
        delete_subvolume "$old_root"
    done <<<"$roots_to_delete"

    return 0
}

main() {
    trap umount_btrfs EXIT

    mount_btrfs
    prune_old_roots
}

main
