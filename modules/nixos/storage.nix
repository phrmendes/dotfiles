{ config, ... }:
let
  inherit (config) settings;
in
{
  flake.modules.nixos.storage =
    { config, ... }:
    {
      fileSystems."/mnt/external" = {
        device = "/dev/disk/by-label/dock";
        fsType = "ext4";
        options = [
          "defaults"
          "noatime"
          "nofail"
        ];
      };

      services.restic.backups = {
        zotero = config.restic.mkBackup "zotero" { paths = [ "/mnt/external/zotero" ]; };
        books = config.restic.mkBackup "books" { paths = [ "/mnt/external/books" ]; };
      };

      systemd.tmpfiles.rules = [
        "d /mnt/external 2775 ${settings.user} external -"
        "a+ /mnt/external - - - - d:g:external:rwx,g:external:rwx,d:group::rwx,group::rwx,d:mask::rwx,mask::rwx"
        "d /mnt/external/books 2775 ${settings.user} external -"
        "d /mnt/external/zotero 2775 ${settings.user} external -"
      ];
    };
}
