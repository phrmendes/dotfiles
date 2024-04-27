# Dotfiles

Dotfiles files for my personal computer.

## Darwin

Install Nix package manager:

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Clone repo and go to the directory:

```sh
git clone https://github.com/phrmendes/dotfiles
cd dotfiles
```

Install nix-darwin:

```sh
nix run nix-darwin -- switch --flake .#darwin
```

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

## KDE

To backup KDE settings:

```sh
nix run github:mcdonc/plasma-manager/enable-look-and-feel-settings > path/to/plasma.nix
```
