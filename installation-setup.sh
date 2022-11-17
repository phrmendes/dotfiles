#!/usr/bin/env bash

# variables

GITHUB_URL="https://raw.githubusercontent.com/phrmendes/bkps/main/flake"
FLAKE_DIR="/mnt/flake"
NIX_FILES=("configuration.nix" "flake.nix" "home.nix")

# create partitions
sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart primary 512MiB 100% # main partition
sudo parted /dev/sda -- mkpart ESP fat32 1Mib 512MiB # efi
sudo parted /dev/sda -- set 2 esp on

# encryption
sudo cryptsetup luksFormat /dev/sda1

# open encrypted partition
sudo cryptsetup luksOpen /dev/sda1 cryptroot

# format partitions
sudo mkfs.fat -F 32 -n boot /dev/sda2
sudo mkfs.ext4 -L nixos /dev/mapper/cryptroot

# mounting partitions
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot/efi
sudo mount /dev/sda2 /mnt/boot

# generate *.nix files
sudo nixos-generate-config --root /mnt

# downloading configuration.nix file
sudo mkdir "$FLAKE_DIR/"

for i in "${NIX_FILES[@]}"; do
    sudo curl "$GITHUB_URL/$i" --output "$FLAKE_DIR/$i"
done

# creating hardware-configuration.nix
sudo sed -i 's/swapDevices = \[ \];/swapDevices = \[\{device = "\/swapfile"; size = 10000;\}\];/g' /mnt/etc/nixos/hardware-configuration.nix

sudo cp /mnt/etc/nixos/hardware-configuration.nix "$FLAKE_DIR"

sudo rm -r /mnt/etc/nixos

# installing
sudo nixos-install --flake .#"$USER"
