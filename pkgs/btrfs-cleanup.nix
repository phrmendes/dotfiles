{
  writeShellApplication,
  btrfs-progs,
  coreutils,
}:
writeShellApplication {
  name = "btrfs-cleanup";
  runtimeInputs = [
    btrfs-progs
    coreutils
  ];
  text = ''
    set -euo pipefail

    BTRFS_DEVICE=/dev/mapper/crypted
    BTRFS_MNT=/btrfs_tmp
    ROOT_SUBVOL=$BTRFS_MNT/root
    OLD_ROOTS=$BTRFS_MNT/old_roots

    delete_subvolume() {
      local subvol="$1"
      IFS=$'\n'
      for child in $(btrfs subvolume list -o "$subvol" | cut -f 9- -d ' '); do
        delete_subvolume "$BTRFS_MNT/$child"
      done
      btrfs subvolume delete "$subvol"
    }

    mkdir -p "$BTRFS_MNT"
    mount "$BTRFS_DEVICE" "$BTRFS_MNT"

    if [[ -e $ROOT_SUBVOL ]]; then
      mkdir -p "$OLD_ROOTS"
      timestamp=$(date --date="@$(stat -c %Y $ROOT_SUBVOL)" "+%Y-%m-%-d_%H:%M:%S")
      mv "$ROOT_SUBVOL" "$OLD_ROOTS/$timestamp"
    fi

    if [[ -d $OLD_ROOTS ]]; then
      while IFS= read -r old_root; do
        delete_subvolume "$old_root"
      done < <(find "$OLD_ROOTS" -maxdepth 1 -mindepth 1 -mtime +7)
    fi

    btrfs subvolume create "$ROOT_SUBVOL"
    umount "$BTRFS_MNT"
  '';
}
