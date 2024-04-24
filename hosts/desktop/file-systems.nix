{
  fileSystems = {
    "/" = {
      fsType = "tmpfs";
      options = ["defaults" "size=10%" "mode=755"];
    };

    "/boot" = {
      device = "/dev/disk/by-partlabel/disk-main-ESP";
      fsType = "vfat";
      options = ["defaults" "umask=0077"];
    };

    "/nix" = {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };

    "/persist" = {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = ["subvol=persist" "compress=zstd" "noatime"];
      neededForBoot = true;
    };
  };
}
