#!/bin/sh
set -e

keep=${KEEP_OLD_ROOTS:?}
top=/top
root=$top/root
old_roots=$top/old_roots

# Mount the top level of the btrfs volume.
mount_top() {
    mkdir -p "$top"
    mount -o subvolid=5 /dev/mapper/crypted "$top"
    mkdir -p "$old_roots"
}

# Succeed when the kernel command line asks to restore an old copy.
restore_requested() {
    read -r cmdline </proc/cmdline
    case " $cmdline " in
    *" nixos.restore_ephemeral=ask "*) ;;
    *) return 1 ;;
    esac
}

# Show the old copies, newest first. Print the name that the user picks.
choose_old_root() {
    set --
    for dir in "$old_roots"/*; do
        [ -e "$dir" ] || continue
        set -- "${dir##*/}" "" "$@"
    done
    [ $# -gt 0 ] || return 0
    choice=$(TERM=linux dialog --timeout 60 --menu "Restore which ephemeral state?" 20 76 12 "$@" 2>&1 1>/dev/console </dev/console) || return 0
    printf '%s\n' "$choice"
}

# Succeed when the name has no slash and no leading dot.
is_plain_name() {
    case $1 in
    "" | */* | .*) return 1 ;;
    esac
}

# Move the current root into old_roots under a unique name.
retire_root() {
    [ -e "$root" ] || return 0
    read -r uuid </proc/sys/kernel/random/uuid
    mv "$root" "$old_roots/$(date +%F_%T)_${uuid%%-*}"
}

# Restore the picked old copy, or create an empty root.
install_root() {
    if is_plain_name "$1" && [ -d "$old_roots/$1" ]; then
        mv "$old_roots/$1" "$root"
    else
        btrfs subvolume create "$root"
    fi
}

# Delete the oldest copies until only $keep remain.
prune_old_roots() {
    set --
    for dir in "$old_roots"/*; do
        [ -e "$dir" ] || continue
        set -- "$@" "$dir"
    done
    while [ $# -gt "$keep" ]; do
        btrfs subvolume delete --recursive "$1"
        shift
    done
}

mount_top

pick=
if restore_requested; then
    pick=$(choose_old_root)
fi

retire_root
install_root "$pick"
prune_old_roots
umount "$top"
