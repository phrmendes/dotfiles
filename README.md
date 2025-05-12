# Dotfiles

Dotfiles files for my personal computer.

## Usage

Clone repo and go to the directory:

```sh
git clone https://github.com/phrmendes/dotfiles
cd dotfiles
```

When using a minimal NixOS ISO, run this to connect to Wi-Fi:

```sh
wpa_passphrase "{ssid}" > wifi.conf
sudo wpa_supplicant -i {interface} -c wifi.conf -B
sudo dhcpcd
```

Disk partitioning:

```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./hosts/shared/disko.nix --arg device '"/dev/{disk}"'
```

Install NixOS:

```sh
sudo nixos-install --flake .#{device} --root /mnt --no-root-passwd
```
