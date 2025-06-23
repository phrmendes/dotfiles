# Dotfiles

Dotfiles files for my personal computer.

## Install NixOS

```sh
sudo nix --experimental-features "nix-command flakes" run "github:nix-community/disko/latest#disko-install" -- \
    --mode format \
    --flake "github:phrmendes/dotfiles#machine" \
    --write-efi-boot-entries \
    --option no-root-passwd
```

# Info

When using a minimal NixOS image, run this to connect to Wi-Fi:

```sh
wpa_passphrase "{ssid}" > wifi.conf
sudo wpa_supplicant -i {interface} -c wifi.conf -B
sudo dhcpcd
```
