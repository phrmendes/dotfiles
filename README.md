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

## Secrets

Generate new key at ~/.config/sops/age/keys.txt

```sh
nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt
```

Generate new key at ~/.config/sops/age/keys.txt from private ssh key at ~/.ssh/private:

```sh
nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/private > ~/.config/sops/age/keys.txt
```

Get a public key of ~/.config/sops/age/keys.txt:

```sh
nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
```
