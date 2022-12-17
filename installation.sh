#!/usr/bin/env bash
GITHUB_URL="https://raw.githubusercontent.com/phrmendes/bkps/nixOS-laptop"
NIX_FILES=("hardware-configuration.nix" "configuration.nix" "home.nix")
NIX_FILES_LOCATION="/mnt/etc/nixos/"

sudo parted /dev/nvme0n1 -- mklabel gpt
sudo parted /dev/nvme0n1 -- mkpart primary 512MiB 100% # main partition
sudo parted /dev/nvme0n1 -- mkpart ESP fat32 1Mib 512MiB # efi
sudo parted /dev/nvme0n1 -- set 2 esp on

sudo cryptsetup luksFormat /dev/nvme0n1p1
sudo cryptsetup luksOpen /dev/nvme0n1p1 cryptroot

sudo mkfs.ext4 -L nixos /dev/mapper/cryptroot
sudo mkfs.fat -F 32 -n boot /dev/nvme0n1p2

sudo mount /dev/mapper/cryptroot /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/nvme0n1p2 /mnt/boot
sudo mkdir -p /mnt/boot/efi

for i in "${NIX_FILES[@]}"; do
    sudo curl "$GITHUB_URL/$i" --output "$NIX_FILES_LOCATION/$i"
done

sudo nixos-install
