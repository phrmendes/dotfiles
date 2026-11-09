# Dotfiles

NixOS + Home Manager for my devices in the [Dendritic Pattern](https://github.com/mightyiam/dendritic).

## Rebuild

```sh
sudo nixos-rebuild switch --flake .#<host>
```

## Install

On the NixOS installer, with `<disk>` from `disko.mainDiskDevice` in the host file:

```sh
git clone https://github.com/phrmendes/dotfiles
cd dotfiles
sudo git config --global --add safe.directory "$PWD"
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest#disko-install -- --flake .#<host> --disk main /dev/disk/by-id/<disk> --write-efi-boot-entries
```

No root password is set. Log in by SSH key, then run `passwd` on `desktop` and `laptop`.

## Steam Deck

`deck` is a standalone Home Manager profile for stock SteamOS. It installs no GUI application.

```sh
sh <(curl -L https://nixos.org/nix/install) --daemon
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
git clone https://github.com/phrmendes/dotfiles ~/.config/dotfiles
cd ~/.config/dotfiles
nix run github:nix-community/home-manager -- switch --flake .#deck
```

## Secrets

```sh
agenix --rekey -r agenix-rules.nix
```

## Restore

```sh
restic-gitolite snapshots
restic-gitolite restore latest --target /tmp/restore
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

Then run `nixos-rebuild boot --flake .#<host>`.
