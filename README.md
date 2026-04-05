# Dotfiles

NixOS configuration using the dendritic pattern with [flake-parts](https://flake.parts).

## Dendritic pattern

Traditional NixOS configurations organize files by configuration class -- NixOS modules in one directory, home-manager modules in another. The dendritic pattern inverts this: files organize by **feature**, not by class. A single file can define both the NixOS and home-manager aspects of a feature (e.g., `hyprland.nix` contains the NixOS `programs.hyprland.enable` and the home-manager window manager config together).

Key principles:

- **Every file is a flake-parts module.** No NixOS modules, no home-manager modules -- just flake-parts modules that define deferred NixOS/HM configurations as option values.
- **`import-tree` auto-imports everything** in `modules/`. No manual import lists to maintain. Adding a feature means creating a file.
- **Hosts compose by selecting aspects.** Each host file picks which features it needs from the module tree. Adding a feature to a host means adding one import.
- **Values share through `let` bindings and flake-parts options**, never through `specialArgs` or `extraSpecialArgs`.

References: [dendritic pattern](https://github.com/mightyiam/dendritic), [import-tree](https://github.com/vic/import-tree), [flake-parts](https://flake.parts).

## Structure

```
flake.nix        # Inputs + mkFlake + import-tree
modules/         # All aspects (auto-imported by import-tree)
hosts/           # Host compositions (explicitly imported)
  desktop.nix
  laptop.nix
  server.nix
```

### Module pattern

Every file in `modules/` is a flake-parts module. Each file defines aspects under a three-level namespace:

```
modules.<class>.<group>.<name>
```

- **class**: `nixos` or `homeManager`
- **group**: `core`, `workstation`, `server`, `dev`, `user`, `media`
- **name**: individual aspect (`boot`, `hyprland`, `git`, etc.)

Multiple files can contribute to the same group. The file name reflects its content domain, not its path in the module tree:

```nix
# modules/boot.nix -- defines modules.nixos.core.{boot, disko, filesystems, swap}
# modules/hyprland.nix -- defines modules.nixos.workstation.hyprland + modules.homeManager.workstation.{hyprland, hypridle, hyprlock, hyprpaper}
```

### Groups

| Group                     | Scope             | Description                                          |
| ------------------------- | ----------------- | ---------------------------------------------------- |
| `nixos.core`              | All machines      | Boot, filesystems, networking, users, services, etc. |
| `nixos.workstation`       | Desktop + laptop  | Hyprland, greetd, pipewire, persistence, secrets     |
| `nixos.server`            | Server only       | Persistence, tailscale, filesystems, secrets         |
| `homeManager.dev`         | Development tools | Neovim, git, tmux, zsh, kitty, etc.                  |
| `homeManager.workstation` | Desktop + laptop  | Waybar, dunst, hyprland HM, keepassxc, etc.          |
| `homeManager.media`       | Desktop + laptop  | imv, mpv, zathura                                    |
| `homeManager.user`        | All machines      | Base HM config, packages, symlinks                   |

### Host composition

Hosts select aspects by group:

```nix
imports =
  (with nixos.core; [ boot disko networking ... ])
  ++ (with nixos.workstation; [ hyprland greetd pipewire ... ]);
```

### Sharing values

- **Global settings** (user, email, home): flake-parts options in `flake-parts.nix`, accessed via `config.settings.*`
- **Per-host values** (machine type, monitors): NixOS options defined in `machine.nix`, set per-host, accessed in HM via `osConfig.machine.*`
- **Within a file**: `let` bindings
- **Never**: `specialArgs` or `extraSpecialArgs`

## Install NixOS

Clone the repo, enter the directory and run:

```sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./hosts/shared/disko.nix --arg parameters '{ device = "/dev/{{ disk }}"; }'
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
