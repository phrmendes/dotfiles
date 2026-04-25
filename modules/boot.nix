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
                  mkdir -p /btrfs_tmp
                  mount -t btrfs -o subvol=/ /dev/mapper/crypted /btrfs_tmp
                  btrfs subvolume delete /btrfs_tmp/root
                  btrfs subvolume create /btrfs_tmp/root
                  umount /btrfs_tmp
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
