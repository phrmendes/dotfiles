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
        "nofail"
      ];
    };

    systemd.tmpfiles.rules = [
      "d /run/sync 0700 ${settings.user} users -"
      "d /mnt/external 2775 ${settings.user} media -"
      "d /mnt/external/zotero 2775 ${settings.user} media -"
      "a+ /mnt/external/zotero - - - - g:media:rwx,d:g:media:rwx"
      "d /srv 0755 root root -"
      "d /srv/containers 0755 root root -"
    ];
  };
}
