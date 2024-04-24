# Dotfiles

Dotfiles files for my personal computer.

## Darwin

Install Nix package manager:

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Install nix-darwin:

```sh
nix run nix-darwin -- switch --flake "/path/to/flake#darwin"
```

## Desktop

Clone repo and go to the directory:

```sh
git clone https://github.com/phrmendes/dotfiles
cd dotfiles
```

Enable flakes:

```sh
export NIX_CONFIG="experimental-features = nix-command flakes"
```

Disk partitioning:

```sh
sudo nix run github:nix-community/disko -- --mode disko ./hosts/desktop/disko.nix --arg device '"/dev/sdX"'
```

Install NixOS:

```sh
sudo nixos-install --flake .#desktop --root /mnt --flake .#desktop
```
