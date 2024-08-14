# Dotfiles

Dotfiles files for my personal computer.

## Desktop

Clone repo and go to the directory:

```sh
git clone https://github.com/phrmendes/dotfiles
cd dotfiles
```

Disk partitioning:

```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./hosts/desktop/disko.nix --arg device '"/dev/sdX"'
```

Install NixOS:

```sh
sudo nixos-install --flake .#desktop --root /mnt --no-root-passwd
```
