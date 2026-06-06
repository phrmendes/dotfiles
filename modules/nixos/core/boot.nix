{ config, ... }:
{
  modules.nixos.core.boot =
    { pkgs, ... }:
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
            services.initrd-btrfs-cleanup = {
              description = "Btrfs subvolume cleanup and recreation";
              requiredBy = [ "sysroot.mount" ];
              before = [ "sysroot.mount" ];
              unitConfig = {
                After = [ "systemd-cryptsetup@crypted.service" ];
                Requires = [ "systemd-cryptsetup@crypted.service" ];
                DefaultDependencies = false;
              };
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
              };
              script = ''
                BTRFS_DEVICE=/dev/mapper/crypted
                BTRFS_MNT=/btrfs_tmp
                ROOT_SUBVOL=$BTRFS_MNT/root
                OLD_ROOTS=$BTRFS_MNT/old_roots

                delete_subvolume() {
                  local subvol="$1"
                  IFS=$'\n'
                  for child in $(btrfs subvolume list -o "$subvol" | cut -f 9- -d ' '); do
                    delete_subvolume "$BTRFS_MNT/$child"
                  done
                  btrfs subvolume delete "$subvol"
                }

                mkdir -p "$BTRFS_MNT"
                mount "$BTRFS_DEVICE" "$BTRFS_MNT"

                if [[ -e $ROOT_SUBVOL ]]; then
                  mkdir -p "$OLD_ROOTS"
                  timestamp=$(date --date="@$(stat -c %Y $ROOT_SUBVOL)" "+%Y-%m-%-d_%H:%M:%S")
                  mv "$ROOT_SUBVOL" "$OLD_ROOTS/$timestamp"
                fi

                if [[ -d $OLD_ROOTS ]]; then
                  while IFS= read -r old_root; do
                    delete_subvolume "$old_root"
                  done < <(find "$OLD_ROOTS" -maxdepth 1 -mindepth 1 -mtime +7)
                fi

                btrfs subvolume create "$ROOT_SUBVOL"
                umount "$BTRFS_MNT"
              '';
            };
          };
        };
      };

      boot.kernel.sysctl."fs.inotify.max_user_watches" = 1048576;

      nixpkgs.hostPlatform = "x86_64-linux";
      console.keyMap = "us";
      system.stateVersion = config.settings.stateVersion;
    };
}
