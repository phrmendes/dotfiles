# Dotfiles

NixOS + Home Manager for `desktop`, `laptop` and `server`, in the [Dendritic Pattern](https://github.com/mightyiam/dendritic).

## Layout

- `modules/nixos/`, `modules/home/` — one aspect per feature, grouped by domain. Every `.nix` file is a flake-parts module, loaded automatically.
- `modules/base.nix` — typed `settings` and the aspect registry.
- `hosts/` — one file per machine: hardware, host name, and one composite aspect (`server` or `workstation`).
- `utils/` — helpers such as `mkVhost`, `mkPostgres` and `mkSecretReadable`.
- `pkgs/`, `files/` — custom packages and static files. Nushell scripts live in `files/scripts/`.
- `secrets/` — [agenix](https://github.com/ryantm/agenix) secrets. The identity is `~/.ssh/age`. Public keys are in `files/ssh/`.
- `agenix-rules.nix` — which host key decrypts which secret.

## Secrets

Rekey after you change `agenix-rules.nix`:

```sh
agenix --rekey -r agenix-rules.nix
```

## Checks

```sh
nix flake check
```

## Restore

Each backup has a `restic-backups-<name>.service` with a timer, and a `restic-<name>` wrapper that already carries the repository and credentials.

```sh
systemctl list-timers 'restic-backups-*'
restic-gitolite snapshots
restic-gitolite restore latest --target /tmp/restore
systemctl start restic-backups-gitolite.service   # run one by hand
```

The repositories are `b2:phrmendes-backups:restic/<name>` for `authelia`, `beszel`, `books`, `databases`, `gitolite`, `home-assistant`, `jellyfin`, `photos`, `sftpgo`, `syncthing` and `zotero`.

Every backup run also executes `restic check --read-data-subset=5%`. Units listed in `notifyOnFailure` report failures to the journal through a `notify-failure-<unit>` service.

## Deploy

The server upgrades from `github:phrmendes/dotfiles#server`, so push before you rely on it. Unpushed commits and unpushed secrets stay stale there.

## Install

```sh
sudo nix run github:nix-community/disko/latest#disko -- --mode disko --flake .#<host>
sudo nixos-install --no-channel-copy --root /mnt --flake .#<host>
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

Then, inside the chroot: `cd <dotfiles> && nixos-rebuild boot --flake .#<host>`.
