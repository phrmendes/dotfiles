# Dotfiles

Dotfiles files for my personal computer.

## Usage

Clone repo and go to the directory:

```sh
git clone https://github.com/phrmendes/dotfiles
cd dotfiles
```

Disk partitioning:

```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./hosts/shared/disko.nix --arg device '"/dev/{disk}"'
```

Install NixOS:

```sh
sudo nixos-install --flake .#{device} --root /mnt --no-root-passwd
```
