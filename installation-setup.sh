#!/usr/bin/env bash

# variables

GITHUB_URL="https://raw.githubusercontent.com/phrmendes/bkps/main/partition.sh"

# create partitions
sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart primary 512MiB 100% # main partition
sudo parted /dev/sda -- mkpart ESP fat32 1Mib 512MiB # efi
sudo parted /dev/sda -- set 2 esp on

# encryption
sudo cryptsetup luksFormat /dev/sda1

# open encrypted partition
sudo cryptsetup luksOpen /dev/sda1 enc-pv

# creating logical volumes
sudo pvcreate /dev/mapper/enc-pv
sudo vgcreate vg /dev/mapper/enc-pv
sudo lvcreate -L 8G -n swap vg # swap
sudo lvcreate -l '100%FREE' -n root vg # system

# format partitions
sudo mkfs.fat -F 32 -n boot /dev/sda2
sudo mkfs.ext4 -L root /dev/vg/root
sudo mkswap -L swap /dev/vg/swap

# mounting partitions
sudo mount /dev/vg/root /mnt
sudo mkdir /mnt/boot
sudo mount /dev/sda2 /mnt/boot
sudo swapon /dev/vg/swap

# generate *.nix files
nixos-generate-config --root /mnt

curl "$GITHUB_URL/configuration.nix" --output /mnt/etc/nixos/configuration.nix
