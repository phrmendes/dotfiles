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

When reinstalling Windows on a dual boot system, the Windows bootloader may overwrite the NixOS bootloader. To fix this, boot into a NixOS live USB and run:

```sh
sudo cryptsetup luksOpen /dev/sdX2 crypted

sudo mount -t btrfs -o subvolid=5 /dev/mapper/crypted /mnt

sudo mkdir -p /mnt/boot /mnt/nix /mnt/persist /mnt/etc

sudo mount -t btrfs -o subvol=nix /dev/mapper/crypted /mnt/nix

sudo mount -t btrfs -o subvol=persist /dev/mapper/crypted /mnt/persist

sudo mount /dev/sdX1 /mnt/boot

sudo mount --bind /mnt/persist/etc /mnt/etc

sudo nixos-enter

NIXOS_INSTALL_BOOTLOADER=1 /nix/var/nix/profiles/system/bin/switch-to-configuration boot
```

Where `X` is the disk letter where NixOS is installed.
