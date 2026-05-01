{ inputs, ... }:
let
  btrfsOpts = [
    "compress=zstd"
    "noatime"
  ];
in
{
  modules.nixos.core.disko =
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
                    "/root".mountpoint = "/";
                    "/root".mountOptions = btrfsOpts;
                    "/nix".mountpoint = "/nix";
                    "/nix".mountOptions = btrfsOpts;
                    "/persist".mountpoint = "/persist";
                    "/persist".mountOptions = btrfsOpts;
                  };
                };
              };
            };
          };
        };
      };
    };
}
