#!/usr/bin/env bash
GITHUB_URL="https://raw.githubusercontent.com/phrmendes/bkps/nixOS"
NIX_FILES=("configuration.nix" "home.nix")
NIX_FILES_LOCATION="/mnt/etc/nixos/"

sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart primary 512MiB 100% # main partition
sudo parted /dev/sda -- mkpart ESP fat32 1Mib 512MiB # efi
sudo parted /dev/sda -- set 2 esp on

sudo cryptsetup luksFormat /dev/sda1
sudo cryptsetup luksOpen /dev/sda1 cryptroot

sudo mkfs.fat -F 32 -n boot /dev/sda2
sudo mkfs.ext4 -L nixos /dev/mapper/cryptroot

sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot/efi
sudo mount /dev/sda2 /mnt/boot

sudo nixos-generate-config --root /mnt

for i in "${NIX_FILES[@]}"; do
    sudo curl "$GITHUB_URL/$i" --output "$NIX_FILES_LOCATION/$i"
done

sudo sed -i 's/swapDevices = \[ \];/swapDevices = \[\{device = "\/swapfile"; size = 10000;\}\];/g' "$NIX_FILES_LOCATION/hardware-configuration.nix"

if grep -Fxq "fileSystems.\"/\" =" "$NIX_FILES_LOCATION/hardware-configuration.nix"; then
    true
else
    REPLACEMENT="fileSystem.\"/\" = { device = \"/dev/disk/by-label/nixos\"; fsType = \"ext4\"; }; }"
    sudo sed -i 's/}$/\${REPLACEMENT}/g' "$NIX_FILES_LOCATION/hardware-configuration.nix"
fi

sudo nixos-install
