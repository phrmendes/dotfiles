# Dotfiles

NixOS + Home Manager configuration built with `flake-parts` and the dendritic pattern.

## Layout

```text
flake.nix        # inputs + mkFlake + import-tree
modules/         # feature modules (auto-imported)
hosts/           # host compositions
  desktop.nix
  laptop.nix
  server.nix
```

Each file in `modules/` is a flake-parts module and typically defines one feature across NixOS and/or Home Manager.

## Module naming

Aspects are exposed as:

```text
modules.<class>.<group>.<name>
```

- `class`: `nixos` or `homeManager`
- `group`: `core`, `workstation`, `server`, `dev`, `user`, `media`
- `name`: feature name (`boot`, `git`, `hyprland`, ...)

## Keys and auth

- age identity is file-based: `~/.ssh/age` and `~/.ssh/age.pub`
- agenix uses `~/.ssh/age` (`modules/age.nix`)
- SSH auth keys are managed by KeePassXC and loaded into OpenSSH `ssh-agent`
- KeePassXC SSH socket override is written to `~/.local/state/keepassxc/keepassxc.ini`
- Git usage is primarily HTTPS (`gh` credential helper)

## Install (new host)

```sh
cat /etc/nix/nix.conf > /tmp/nix.conf
echo "experimental-features = nix-command flakes pipe-operators" >> /tmp/nix.conf
sudo mv /tmp/nix.conf /etc/nix/nix.conf
sudo nix --experimental-features "nix-command flakes pipe-operators" run github:nix-community/disko/latest#disko -- --mode disko --flake .#{{ machine }}
sudo nixos-install --no-channel-copy --root /mnt --flake .#{{ machine }}
```

## Workflow

After cloning, install hooks once:

```sh
prek install
```

Common commands:

```sh
just fmt
just lint
just rebuild
```

## Troubleshooting

### chroot into the system

```sh
sudo cryptsetup luksOpen /dev/sdX2 crypted
sudo mount -t btrfs -o subvolid=5 /dev/mapper/crypted /mnt
sudo mkdir -p /mnt/boot /mnt/nix /mnt/persist /mnt/etc
sudo mount -t btrfs -o subvol=nix /dev/mapper/crypted /mnt/nix
sudo mount -t btrfs -o subvol=persist /dev/mapper/crypted /mnt/persist
sudo mount /dev/sdX1 /mnt/boot
sudo mount --bind /mnt/persist/etc /mnt/etc
sudo nixos-enter
```

Replace `X` with your disk letter.
