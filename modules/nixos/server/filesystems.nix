{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.server.filesystems = {
    fileSystems."/mnt/external" = {
      device = "/dev/disk/by-label/external";
      fsType = "ext4";
      options = [
        "defaults"
        "noatime"
      ];
    };

    systemd.tmpfiles.rules = [
      "d /run/sync 0700 ${settings.user} users -"
      "d /mnt/external 2777 ${settings.user} users -"
      "a+ /mnt/external - - - - u:${settings.user}:rwx,u:100999:rwx,o::rwx,d:u:${settings.user}:rwx,d:u:100999:rwx,d:o::rwx"
    ];
  };
}
