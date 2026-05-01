_:
let
  btrfsOpts = [
    "compress=zstd"
    "noatime"
  ];
  btrfsMount = subvol: {
    device = "/dev/mapper/crypted";
    fsType = "btrfs";
    options = [ "subvol=${subvol}" ] ++ btrfsOpts;
  };
in
{
  modules.nixos.core.filesystems = {
    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-partlabel/disk-main-ESP";
        fsType = "vfat";
        options = [
          "defaults"
          "umask=0077"
        ];
      };
      "/" = btrfsMount "root";
      "/nix" = btrfsMount "nix";
      "/persist" = (btrfsMount "persist") // {
        neededForBoot = true;
      };
    };
  };
}
