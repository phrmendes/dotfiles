{ lib, ... }:
{
  modules.nixos.core.filesystems = {
    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-partlabel/disk-main-ESP";
        fsType = "vfat";
        options = [
          "umask=0077"
        ];
      };
      "/persist".neededForBoot = lib.mkForce true;
    };
  };
}
