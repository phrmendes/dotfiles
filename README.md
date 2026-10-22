# Dotfiles

NixOS + Home Manager configuration for three machines — desktop, laptop, and server. Follows the [Dendritic Pattern](https://github.com/mightyiam/dendritic).

## Structure

```
flake.nix            — inputs and mkFlake entry point
modules/             — every file is a flake-parts module (auto-imported)
  base.nix           — settings, flake.modules registry, nixosSystem builder, checks, treefmt
  nixos/             — NixOS aspects, grouped in system/, workstation/, server/ and media/
  home/              — Home Manager aspects, grouped in core/, cli/, dev/ and desktop/
utils/               — helpers (mkVhost, mkPostgres, mkSecretReadable, ...)
pkgs/                — custom packages
files/               — static files; scripts live in files/scripts/
secrets/             — agenix-encrypted secrets
hosts/               — per-machine compositions
  desktop.nix
  laptop.nix
  server.nix
```

## Key concepts

- **Every `.nix` file is a top-level module** — auto-imported by import-tree
- **Composite aspects** — `server` and `workstation` import the aspects every host of that kind needs, plus its inline defaults. A host file imports one composite, adds hardware, and sets `networking.hostName`. The `workstation` aspect imports `audio`, `bluetooth`, `core`, `disko`, `podman`, `resolved`, `session`, `syncthingWorkstation` and `tailscale`. The `server` aspect lists the services
- **`workstation`** — per-host attrset (`type`, `dotfilesDir`, `monitors`), set by desktop/laptop
- **`settings`** — typed options (`user`, `home`, `serverDomain`, `lan.*`, ...). A value with one consumer stays in that file
- **Aspects** — a file registers `flake.modules.nixos.<name>` and, when it has a user-level part, `flake.modules.homeManager.<name>`. Hosts only import aspects
- **Shared options** — a feature registers itself in `homepage.services`, `caddy.mkVhost`, `restic.mkBackup` and `utils.mkPostgres`, so a service file owns its vhost, database, secret and backup
- **Forced passphrase** — the laptop imports `forcePassphrase`. The TPM PIN works for 48 hours after a boot that asked for the full passphrase. After that, the initrd changes PCR 7 for one boot, the TPM refuses the PIN, and the boot asks for the passphrase. The next boot uses the PIN again. A stamp on the ESP records the time. `pin status` shows it, and `pin create` and `pin edit` refuse to run in a boot that asked for the passphrase
- **Module header** — a file takes `{ config, ... }:` and `inherit (config) settings;` only when it needs shared `settings`, and `{ inputs, ... }:` only when it needs flake inputs

## Scripts

Nushell scripts live in `files/scripts/`. `pkgs/default.nix` packages them as `pkgs.local.<name>`.

- **`lib.nu`** — helpers that scripts share. `fail` raises an error with a label.
- **`writeNuBin`** — builds a command from a script. It sets `NU_LIB_DIRS` in the shebang, so a script writes `use lib.nu fail`.
- **`backup-sqlite <source> <destination>`** — copies a live SQLite database as a consistent snapshot and checks the copy. The Beszel and Jellyfin backups use it.
- **`pin`**, **`get-wg-ip`** — use `writeNuBin`. `pin` manages the TPM PIN of the disk. `get-wg-ip` prints the WireGuard addresses of the machine.
- **`vpn`** — starts and stops the home tunnel, and shows its state. It uses the plain `writers.writeNuBin`.
- **`sync-repos`** — mirrors the public GitHub repositories into Gitolite.

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
