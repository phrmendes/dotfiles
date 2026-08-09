# Dotfiles

NixOS + Home Manager configuration for three machines — desktop, laptop, and server.
Follows the [Dendritic Pattern](https://github.com/mightyiam/dendritic).

## Structure

```
flake.nix            — inputs and mkFlake entry point
modules/             — every file is a flake-parts module (auto-imported)
  base.nix           — nixosSystem builder, checks, treefmt
  options.nix        — all option declarations (flake-parts + NixOS)
  lib.nix            — dotfilesLib (mkSecretReadable, mkVhost, etc.)
  nixos/             — NixOS modules (flat, no subdirectories)
  home/              — Home Manager modules
pkgs/                — custom packages
files/               — config files (out-of-store symlinks)
secrets/             — agenix-encrypted secrets
hosts/               — per-machine compositions
  desktop.nix
  laptop.nix
  server.nix
```

## Key concepts

- **Every `.nix` file is a top-level module** — auto-imported by import-tree
- **`options.nix`** — single source of truth for all option types
- **`workstation`** — per-host attrset (`type`, `dotfilesDir`, `monitors`), set by desktop/laptop
- **Flat NixOS modules** — `nixosModules.<name>`, no nested directories

## Install

Enable flakes, partition with disko, then install:

```sh
sudo nix run github:nix-community/disko/latest#disko -- --mode disko --flake .#{{ host }}
sudo nixos-install --no-channel-copy --root /mnt --flake .#{{ host }}
```

## Secrets

Secrets are encrypted with [agenix](https://github.com/ryantm/agenix) using SSH keys.

- Identity: `~/.ssh/age`
- Public keys: `files/ssh/`

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

In chroot:

```sh
cd {{ path to dotfiles repo in chroot }}
nixos-rebuild boot --flake .#desktop
```
