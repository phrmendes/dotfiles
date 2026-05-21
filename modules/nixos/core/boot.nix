{ config, ... }:
{
  modules.nixos.core.boot =
    { pkgs, lib, ... }:
    {
      boot = {
        tmp.cleanOnBoot = true;
        kernelPackages = pkgs.linuxPackages;

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

        kernelModules = [
          "fuse"
        ];

        initrd = {
          kernelModules = [
            "tun"
          ];

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
            packages = [ pkgs.local.btrfs-cleanup ];
            services.initrd-btrfs-cleanup = {
              description = "Btrfs subvolume cleanup and recreation";
              requiredBy = [ "sysroot.mount" ];
              before = [ "sysroot.mount" ];
              unitConfig.RequiresMountsFor = "/dev/mapper/crypted";
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                ExecStart = lib.getExe pkgs.local.btrfs-cleanup;
              };
            };
          };
        };
      };

      nixpkgs.hostPlatform = "x86_64-linux";
      console.keyMap = "us";
      system.stateVersion = config.settings.stateVersion;
    };
}
