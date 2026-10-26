_:
let
  btrfsTop = "/run/btrfs";
  keepOldRoots = 5;
in
{
  flake.modules.nixos.boot =
    { lib, pkgs, ... }:
    {

      specialisation.restore-old-root.configuration = {
        system.nixos.distroName = "NixOS (choose an old root to restore)";
        boot.kernelParams = [ "nixos.restore_old_root=ask" ];
      };

      boot = {
        kernel.sysctl."fs.inotify.max_user_watches" = 1048576;
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
          limine = {
            enable = true;
            maxGenerations = 3;
          };
        };
        kernelModules = [ "fuse" ];
        initrd = {
          kernelModules = [ "tun" ];
          availableKernelModules = [
            "xhci_pci"
            "ahci"
            "usb_storage"
            "usbhid"
            "sd_mod"
            "nvme"
            "tpm_tis"
            "tpm_crb"
          ];
          luks.devices."crypted" = {
            device = "/dev/disk/by-partlabel/disk-main-luks";
            crypttabExtraOpts = [ "tpm2-device=auto" ];
          };
          systemd = {
            initrdBin = with pkgs; [ dialog ];
            contents = {
              "/etc/dialogrc".source = ../../../files/dialogrc;
            };
            services = {
              systemd-udevd.after = [ "systemd-modules-load.service" ]; # Workaround for https://github.com/NixOS/nixpkgs/issues/428775
              wipe-root = {
                description = "Wipe the root filesystem and keep the newest old copies";
                requiredBy = [ "sysroot.mount" ];
                before = [ "sysroot.mount" ];
                after = [ "systemd-cryptsetup@crypted.service" ];
                requires = [ "systemd-cryptsetup@crypted.service" ];
                unitConfig.DefaultDependencies = false;
                serviceConfig = {
                  Type = "oneshot";
                  RemainAfterExit = true;
                };
                environment.KEEP_OLD_ROOTS = toString keepOldRoots;
                script = builtins.readFile ../../../files/scripts/wipe-root.sh;
              };
            };
          };
        };
      };

      fileSystems = {
        "/persist".neededForBoot = lib.mkForce true;
        "/boot" = {
          device = "/dev/disk/by-partlabel/disk-main-ESP";
          fsType = "vfat";
          options = lib.mkBefore [ "umask=0077" ];
        };
        ${btrfsTop} = {
          device = "/dev/mapper/crypted";
          fsType = "btrfs";
          options = [
            "subvolid=5"
            "noatime"
            "compress=zstd"
            "nofail"
          ];
        };
      };

      swapDevices = [
        {
          device = "/persist/swapfile";
          size = 8192;
        }
      ];

      hardware = {
        enableAllFirmware = true;
        uinput.enable = true;
      };
    };
}
