# Dotfiles

NixOS + Home Manager for my devices in the [Dendritic Pattern](https://github.com/mightyiam/dendritic).

## Install

### NixOS

On the NixOS installer, with `<disk>` from `disko.mainDiskDevice` in the host file:

```bash
git clone https://github.com/phrmendes/dotfiles
cd dotfiles
sudo git config --global --add safe.directory "$PWD"
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest#disko-install -- --flake .#<host> --disk main /dev/disk/by-id/<disk> --write-efi-boot-entries
```

No root password is set. Log in by SSH key, then run `passwd` on `desktop` and `laptop`.

### Steam Deck

`deck` is a standalone Home Manager profile for stock SteamOS. It installs no GUI application.

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
git clone https://github.com/phrmendes/dotfiles ~/.config/dotfiles
cd ~/.config/dotfiles
nix run github:nix-community/home-manager -- switch --flake .#deck
```

### KVM

Reserve `192.168.10.5` for the Pi. Build the SD image on `desktop` with ARM emulation enabled:

```bash
nix develop -c nix build .#nixosConfigurations.kvm.config.system.build.sdImage
```

Identify the SD card with `lsblk` and unmount its partitions.

Replace `/dev/<device>` with the whole SD card. This command erases it:

```bash
zstd --decompress --stdout result/sd-image/*.img.zst | sudo dd of=/dev/<device> bs=4M conv=fsync status=progress
```

Connect Ethernet, boot the Pi, and create the PiKVM login:

```bash
ssh -t phrmendes@192.168.10.5 'sudo -u kvmd kvmd-htpasswd add admin'
```

## Secrets

After changing recipients in `agenix-rules.nix`, re-encrypt the existing secrets:

```bash
agenix --rekey
```

## Restore backups (server)

```bash
restic-gitolite snapshots
restic-gitolite restore latest --target /tmp/restore
```

## Recovery (chroot)

```bash
sudo cryptsetup luksOpen /dev/sdX2 crypted
sudo mount -t btrfs -o subvolid=5 /dev/mapper/crypted /mnt
sudo mount -t btrfs -o subvol=nix /dev/mapper/crypted /mnt/nix
sudo mount -t btrfs -o subvol=persist /dev/mapper/crypted /mnt/persist
sudo mount /dev/sdX1 /mnt/boot
sudo mount --bind /mnt/persist/etc /mnt/etc
sudo mount --bind /etc/resolv.conf /mnt/etc/resolv.conf
sudo nixos-enter
```

Then run `nixos-rebuild boot --flake .#<host>`.
