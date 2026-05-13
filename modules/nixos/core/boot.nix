{ config, ... }:
{
  modules.nixos.core.boot =
    { pkgs, ... }:
    {
      boot = {
        tmp.cleanOnBoot = true;
        kernelPackages = pkgs.linuxPackages_6_12;

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
            configurationLimit = 30;
          };
        };

        kernelModules = [
          "tun"
          "fuse"
        ];

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
                set -euo pipefail

                mkdir -p /btrfs_tmp
                mount /dev/mapper/crypted /btrfs_tmp

                delete_subvolume_recursively() {
                  while IFS= read -r subvol; do
                    delete_subvolume_recursively "/btrfs_tmp/$subvol"
                  done < <(btrfs subvolume list -o "$1" | awk '{print $NF}')
                  btrfs subvolume delete "$1"
                }

                if [[ -e /btrfs_tmp/root ]]; then
                  delete_subvolume_recursively /btrfs_tmp/root
                fi

                btrfs subvolume create /btrfs_tmp/root
                umount /btrfs_tmp
              '';
            };
          };
        };
      };

      nixpkgs.hostPlatform = "x86_64-linux";
      console.keyMap = "us";
      system.stateVersion = config.settings.stateVersion;
    };
}
