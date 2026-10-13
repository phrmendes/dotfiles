BTRFS_DEVICE=/dev/mapper/crypted
BTRFS_MNT=/btrfs_tmp
ROOT_SUBVOL=$BTRFS_MNT/root
OLD_ROOTS=$BTRFS_MNT/old_roots
KEEP_OLD_ROOTS=5

# Recursively delete a subvolume and its nested subvolumes.
delete_subvolume() {
    local subvol="$1"
    local IFS=$'\n'
    local nested_subvolumes
    nested_subvolumes=$(btrfs subvolume list -o "$subvol" | cut -f 9- -d ' ')

    for child in "${nested_subvolumes[@]}"; do
        delete_subvolume "$BTRFS_MNT/$child"
    done

    btrfs subvolume delete "$subvol"
}

# Move the current root into old_roots under a unique, timestamped name.
retire_root() {
    if [[ ! -e $ROOT_SUBVOL ]]; then
        return 0
    fi

    mkdir -p "$OLD_ROOTS"

    local root_mtime root_created unique_suffix target
    root_mtime=$(stat -c %Y "$ROOT_SUBVOL")
    root_created=$(date --date="@$root_mtime" "+%Y-%m-%-d_%H:%M:%S")
    unique_suffix=$(od -An -N4 -tx1 /dev/urandom | tr -d ' ')
    target=$OLD_ROOTS/${root_created}_$unique_suffix

    mv "$ROOT_SUBVOL" "$target"
}

# Keep only the newest $KEEP_OLD_ROOTS old roots. Best effort: never fail the boot.
prune_old_roots() {
    if [[ ! -d $OLD_ROOTS ]]; then
        return 0
    fi

    local roots_newest_first roots_to_delete old_root
    roots_newest_first=$(find "$OLD_ROOTS" -maxdepth 1 -mindepth 1 -printf '%T@\t%p\n' | sort -rn)
    roots_to_delete=$(tail -n +$((KEEP_OLD_ROOTS + 1)) <<<"$roots_newest_first" | cut -f 2-)

    if [[ -z $roots_to_delete ]]; then
        return 0
    fi

    while IFS= read -r old_root; do
        delete_subvolume "$old_root" || true
    done <<<"$roots_to_delete"
}

mkdir -p "$BTRFS_MNT"
mount "$BTRFS_DEVICE" "$BTRFS_MNT"

retire_root
prune_old_roots

btrfs subvolume create "$ROOT_SUBVOL"
umount "$BTRFS_MNT"
