# Dotfiles

NixOS + Home Manager for `desktop`, `laptop` and `server`, in the [Dendritic Pattern](https://github.com/mightyiam/dendritic).

`<host>` is `desktop`, `laptop` or `server`. `<disk>` is `disko.mainDiskDevice` from that host file.

## Rebuild

```sh
sudo nixos-rebuild switch --flake .#<host>
```

## Install

On the NixOS installer:

```sh
git clone https://github.com/phrmendes/dotfiles
cd dotfiles
sudo git config --global --add safe.directory "$PWD"
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest#disko-install -- --flake .#<host> --disk main /dev/disk/by-id/<disk> --write-efi-boot-entries
```

No root password is set. Log in by SSH key, then `passwd` on `desktop` and `laptop`.

## Deploy

```sh
git push   # the server upgrades from github:phrmendes/dotfiles#server
```

## Secrets

```sh
agenix --rekey -r agenix-rules.nix
```

## Restore

```sh
systemctl list-timers 'restic-backups-*'
restic-gitolite snapshots
restic-gitolite restore latest --target /tmp/restore
systemctl start restic-backups-gitolite.service   # run one now
```

## Recovery (chroot)

```sh
sudo cryptsetup luksOpen /dev/sdX2 crypted
sudo mount -t btrfs -o subvolid=5 /dev/mapper/crypted /mnt
sudo mount -t btrfs -o subvol=nix /dev/mapper/crypted /mnt/nix
sudo mount -t btrfs -o subvol=persist /dev/mapper/crypted /mnt/persist
sudo mount /dev/sdX1 /mnt/boot
sudo mount --bind /mnt/persist/etc /mnt/etc
sudo mount --bind /etc/resolv.conf /mnt/etc/resolv.conf
sudo nixos-enter
```

```sh
cd <dotfiles> && nixos-rebuild boot --flake .#<host>
```
