# Dotfiles

Dotfiles files for my personal computer.

## Install NixOS

Clone the repo, enter in the directory and run these commmands:

```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./hosts/shared/disko.nix --arg device '"/dev/{{ disk }}"'
sudo nixos-install --no-channel-copy --no-root-password --root /mnt --flake .#{{ machine }}
```

# Info

When using a minimal NixOS image, run this to connect to Wi-Fi:

```sh
wpa_passphrase "{{ ssid }}" > wifi.conf
sudo wpa_supplicant -i {{ interface }} -c wifi.conf -B
sudo dhcpcd
```
