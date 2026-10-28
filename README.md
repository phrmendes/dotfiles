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
