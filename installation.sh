#!/usr/bin/env bash
GITHUB_URL="https://raw.githubusercontent.com/phrmendes/bkps/nixOS-pc"
NIX_FILES=("hardware-configuration.nix" "configuration.nix" "home.nix")
NIX_FILES_LOCATION="/mnt/etc/nixos/"

sudo parted /dev/sdc -- mklabel gpt
sudo parted /dev/sdc -- mkpart primary 512MiB 100% # main partition
sudo parted /dev/sdc -- mkpart ESP fat32 1Mib 512MiB # efi
sudo parted /dev/sdc -- set 2 esp on

sudo cryptsetup luksFormat /dev/sdc1
sudo cryptsetup luksOpen /dev/sdc1 cryptroot

sudo mkfs.fat -F 32 -n boot /dev/sdc2
sudo mkfs.ext4 -L nixos /dev/mapper/cryptroot

sudo mount /dev/mapper/cryptroot /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/sdc2 /mnt/boot
sudo mkdir -p /mnt/boot/efi

sudo nixos-generate-config --root /mnt

for i in "${NIX_FILES[@]}"; do
    sudo curl "$GITHUB_URL/$i" --output "$NIX_FILES_LOCATION/$i"
done

sudo nixos-install
