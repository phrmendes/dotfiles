# Dotfiles

Dotfiles files for my personal computer.

## Install NixOS

Clone the repo, enter in the directory and run these commmands:

```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./hosts/shared/disko.nix --arg device '"/dev/{{ disk }}"'
sudo nixos-install --no-channel-copy --root /mnt --flake .#{{ machine }}
```

When using a minimal NixOS image, run this to connect to Wi-Fi:

```sh
wpa_passphrase "{{ ssid }}" > wifi.conf
sudo wpa_supplicant -i {{ interface }} -c wifi.conf -B
sudo dhcpcd
```

## Troubleshooting

When Tailscale fails to start because of TPM lockout, run this command to clear it:

```sh
sudo tpm2_dictionarylockout -c -T device:/dev/tpmrm0
```
