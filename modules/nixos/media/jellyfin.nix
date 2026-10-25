{
  flake.modules.nixos.jellyfin =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      backupDir = "/var/backup/jellyfin";
    in
    {
      homepage.services.jellyfin = {
        url = "jellyfin.${config.caddy.domain}";
        homepage = {
          name = "Jellyfin";
          description = "Media server";
          icon = "sh-jellyfin";
          category = "Media";
        };
      };

      users.users.jellyfin.extraGroups = [ "external" ];

      services = {
        jellyfin = {
          enable = true;
          openFirewall = true;
        };
        caddy.virtualHosts = config.caddy.mkVhost {
          name = "jellyfin";
          port = 8096;
        };
        restic.backups.jellyfin = config.restic.mkBackup "jellyfin" {
          paths = [
            "/var/lib/jellyfin"
            backupDir
          ];
          exclude = [
            "/var/lib/jellyfin/metadata"
            "/var/lib/jellyfin/data/metadata"
            "/var/lib/jellyfin/data/transcodes"
            "/var/lib/jellyfin/cache"
            "/var/lib/jellyfin/log"
            "/var/lib/jellyfin/.cache"
            "*.db"
            "*.db-wal"
            "*.db-shm"
          ];
          backupPrepareCommand = "${lib.getExe pkgs.local.backup-sqlite} /var/lib/jellyfin/data/jellyfin.db ${backupDir}/library.sqlite";
        };
      };
    };
}
