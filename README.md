# Dotfiles

NixOS + Home Manager configuration for three machines — desktop, laptop, and server.

## Structure

```
flake.nix          — inputs and mkFlake entry point
modules/           — feature modules (auto-imported via import-tree)
  flake-parts.nix  — global settings and options
  lib.nix          — shared helper functions (dotfilesLib)
  nixos/           — NixOS modules
    core/          — shared across all machines
    server/        — server-only services
    workstation/   — desktop and laptop only
  hm/              — Home Manager modules
    user/          — all users
    dev/           — development tools
    workstation/   — workstation UI and apps
pkgs/              — custom packages
files/             — config files managed as out-of-store symlinks
secrets/           — agenix-encrypted secrets
hosts/             — per-machine compositions
  desktop.nix
  laptop.nix
  server.nix
```

## Server services

| Service                             | URL                                |
| ----------------------------------- | ---------------------------------- |
| AdGuard Home                        | `adguardhome.local.phrmendes.xyz`  |
| Atuin                               | `atuin.local.phrmendes.xyz`        |
| Beszel                              | `beszel.local.phrmendes.xyz`       |
| Duplicati                           | `duplicati.local.phrmendes.xyz`    |
| Excalidraw                          | `excalidraw.local.phrmendes.xyz`   |
| Homepage                            | `homepage.local.phrmendes.xyz`     |
| Jellyfin                            | `jellyfin.local.phrmendes.xyz`     |
| Linkding                            | `linkding.local.phrmendes.xyz`     |
| SFTPGo                              | `sftpgo.local.phrmendes.xyz`       |
| Sonarr / Radarr / Prowlarr / Bazarr | `*.local.phrmendes.xyz`            |
| Syncthing                           | `syncthing.local.phrmendes.xyz`    |
| Transmission                        | `transmission.local.phrmendes.xyz` |
| WebDAV                              | `webdav.local.phrmendes.xyz`       |

## Install

Enable flakes, partition with disko, then install:

```sh
sudo nix run github:nix-community/disko/latest#disko -- --mode disko --flake .#<host>
sudo nixos-install --no-channel-copy --root /mnt --flake .#<host>
```

## Workflow

Install pre-commit hooks once after cloning:

```sh
prek install
```

Then use the justfile:

```sh
just fmt      # format
just lint     # lint
just rebuild  # nh os switch
```

## Secrets

Secrets are encrypted with [agenix](https://github.com/ryantm/agenix) using SSH keys.

- Identity: `~/.ssh/age`
- Declarations: `secrets/secrets.nix`
- SSH keys for encryption: `files/ssh-keys/`

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
