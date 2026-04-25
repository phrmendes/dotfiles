{ inputs, ... }:
{
  modules.nixos.core = {
    disko =
      { lib, config, ... }:
      {
        imports = [ inputs.disko.nixosModules.disko ];
        options.disko.mainDiskDevice = lib.mkOption {
          type = lib.types.str;
          description = "Device path for the main disk";
        };

        config.disko.devices.disk.main = {
          device = config.disko.mainDiskDevice;
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "defaults" ];
                };
              };
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted";
                  settings.allowDiscards = true;
                  content = {
                    type = "btrfs";
                    extraArgs = [ "-f" ];
                    subvolumes = {
                      "/root" = {
                        mountpoint = "/";
                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                      };
                      "/nix" = {
                        mountpoint = "/nix";
                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                      };
                      "/persist" = {
                        mountpoint = "/persist";
                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };

    boot =
      { pkgs, lib, ... }:
      {
        boot = {
          tmp.cleanOnBoot = true;
          kernelPackages = pkgs.linuxPackages_latest;

          supportedFilesystems = [
            "btrfs"
            "ntfs"
          ];

          loader = {
            timeout = 5;
            efi = {
              canTouchEfiVariables = true;
              efiSysMountPoint = "/boot";
            };
            systemd-boot = {
              enable = true;
              configurationLimit = 10;
            };
          };

          kernelModules = [ "tun" ];

          initrd = {
            availableKernelModules = [
              "xhci_pci"
              "ahci"
              "usb_storage"
              "usbhid"
              "sd_mod"
              "nvme"
            ];
            luks.devices."crypted".device = "/dev/disk/by-partlabel/disk-main-luks";
            systemd = {
              enable = true;
              services.initrd-btrfs-cleanup = {
                description = "Btrfs subvolume cleanup and recreation";
                requiredBy = [ "sysroot.mount" ];
                before = [ "sysroot.mount" ];
                unitConfig.RequiresMountsFor = "/dev/mapper/crypted";
                serviceConfig = {
                  Type = "oneshot";
                  RemainAfterExit = true;
                };
                script = ''
                  set +e

                  cleanup() {
                    mountpoint -q /btrfs_tmp && umount /btrfs_tmp
                  }
                  trap cleanup EXIT

                  mkdir -p /btrfs_tmp

                  mount -t btrfs -o subvol=/ /dev/mapper/crypted /btrfs_tmp || {
                    echo "ERROR: failed to mount btrfs top-level, skipping cleanup"
                    exit 0
                  }

                  delete_subvolume_recursively() {
                    local subvol
                    while IFS= read -r subvol; do
                      delete_subvolume_recursively "/btrfs_tmp/$subvol"
                    done < <(btrfs subvolume list -o "$1" | cut -f 9- -d ' ')
                    btrfs subvolume delete "$1" || echo "WARNING: failed to delete subvolume $1"
                  }

                  rotate_root() {
                    btrfs subvolume list /btrfs_tmp | grep -q 'path root$' || return 0

                    local timestamp
                    timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H:%M:%S")

                    mkdir -p /btrfs_tmp/old_roots

                    btrfs subvolume snapshot /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp" || {
                      echo "ERROR: failed to snapshot root, skipping deletion"
                      return 0
                    }

                    delete_subvolume_recursively /btrfs_tmp/root || echo "WARNING: failed to delete old root subvolume"
                  }

                  cleanup_old_snapshots() {
                    [ -d /btrfs_tmp/old_roots ] || return 0

                    find /btrfs_tmp/old_roots -maxdepth 1 -mindepth 1 -mtime +30 | while read -r snapshot; do
                      delete_subvolume_recursively "$snapshot" || echo "WARNING: failed to delete snapshot $snapshot"
                    done
                  }

                  create_root() {
                    btrfs subvolume list /btrfs_tmp | grep -q 'path root$' && return 0

                    btrfs subvolume create /btrfs_tmp/root || echo "ERROR: failed to create root subvolume"
                  }

                  rotate_root
                  cleanup_old_snapshots
                  create_root

                  exit 0
                '';
              };
            };
          };
        };

        nixpkgs.hostPlatform = "x86_64-linux";
        console.keyMap = "us";
        system.stateVersion = "26.05";
      };

    filesystems = {
      fileSystems = {
        "/boot" = {
          device = "/dev/disk/by-partlabel/disk-main-ESP";
          fsType = "vfat";
          options = [
            "defaults"
            "umask=0077"
          ];
        };
        "/" = {
          device = "/dev/mapper/crypted";
          fsType = "btrfs";
          options = [
            "subvol=root"
            "compress=zstd"
            "noatime"
          ];
        };
        "/nix" = {
          device = "/dev/mapper/crypted";
          fsType = "btrfs";
          options = [
            "subvol=nix"
            "compress=zstd"
            "noatime"
          ];
        };
        "/persist" = {
          device = "/dev/mapper/crypted";
          fsType = "btrfs";
          options = [
            "subvol=persist"
            "compress=zstd"
            "noatime"
          ];
          neededForBoot = true;
        };
      };
    };

    swap = {
      swapDevices = [
        {
          device = "/persist/swapfile";
          size = 8192;
        }
      ];
    };
  };
}
