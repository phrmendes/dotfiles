# Dotfiles

NixOS + Home Manager configuration for three machines — desktop, laptop, and server.

## Structure

```
flake.nix        — inputs and mkFlake entry point
modules/         — feature modules (auto-imported via import-tree)
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
hosts/           — per-machine compositions
  desktop.nix
  laptop.nix
  server.nix
pkgs/            — custom packages
files/           — config files managed as out-of-store symlinks
secrets/         — agenix-encrypted secrets
```

## Machines

| Host      | Type        | Notable                                   |
| --------- | ----------- | ----------------------------------------- |
| `desktop` | Workstation | AMD CPU, NVIDIA GPU, Hyprland             |
| `laptop`  | Workstation | Intel CPU, Hyprland, power management     |
| `server`  | Headless    | Intel Celeron J3455, self-hosted services |

## Server services

| Service                             | URL                                    |
| ----------------------------------- | -------------------------------------- |
| AdGuard Home                        | `adguardhome.local.ohlongjohnson.tech` |
| Atuin                               | `atuin.local.ohlongjohnson.tech`       |
| Beszel                              | `beszel.local.ohlongjohnson.tech`      |
| Duplicati                           | `duplicati.local.ohlongjohnson.tech`   |
| Excalidraw                          | `excalidraw.local.ohlongjohnson.tech`  |
| Homepage                            | `homepage.local.ohlongjohnson.tech`    |
| Jellyfin                            | `jellyfin.local.ohlongjohnson.tech`    |
| Linkding                            | `linkding.local.ohlongjohnson.tech`    |
| LiteLLM                             | `litellm.local.ohlongjohnson.tech`     |
| SFTPGo                              | `sftpgo.local.ohlongjohnson.tech`      |
| Sonarr / Radarr / Prowlarr / Bazarr | `*.local.ohlongjohnson.tech`           |
| Syncthing                           | `syncthing.local.ohlongjohnson.tech`   |
| WebDAV                              | `webdav.local.ohlongjohnson.tech`      |

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
sudo nixos-enter
```
