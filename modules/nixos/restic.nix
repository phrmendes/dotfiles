{
  nixosModules.restic =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.utils) mkSqliteBackup;
      bucket = "b2:phrmendes-backups:restic";
      databases = {
        dir = "/var/backup/databases";
        paths = {
          atuin = "/var/lib/atuin/atuin.db";
          authelia = "/var/lib/authelia/db.sqlite3";
          bazarr = "/var/lib/bazarr/db/bazarr.db";
          beszel = "/var/lib/beszel/beszel_data/data.db";
          linkding = "/var/lib/linkding/db.sqlite3";
          prowlarr = "/var/lib/prowlarr/prowlarr.db";
          radarr = "/var/lib/radarr/radarr.db";
          sftpgo = "/var/lib/sftpgo/sftpgo.db";
          sonarr = "/var/lib/sonarr/sonarr.db";
          wg-easy = "/var/lib/wg-easy/wg-easy.db";
        };
      };
      common = {
        environmentFile = config.age.secrets."restic.env".path;
        initialize = true;
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 4"
          "--keep-monthly 6"
        ];
        timerConfig = {
          OnCalendar = "03:00";
          Persistent = true;
        };
      };
    in
    {
      services.restic.backups = {
        photos = common // {
          repository = "${bucket}/photos";
          paths = [
            "/mnt/external/photos/backups"
            "/mnt/external/photos/library"
          ];
        };
        syncthing = common // {
          repository = "${bucket}/syncthing";
          paths = [ "/mnt/external/syncthing" ];
          exclude = [
            "/mnt/external/syncthing/reading"
            "/mnt/external/syncthing/files"
          ];
        };
        zotero = common // {
          repository = "${bucket}/zotero";
          paths = [ "/mnt/external/zotero" ];
        };
        databases = common // {
          repository = "${bucket}/databases";
          paths = [ databases.dir ];
          backupPrepareCommand = mkSqliteBackup {
            inherit (databases) dir paths;
            sqlite3 = lib.getExe pkgs.sqlite;
          };
        };
        books = common // {
          repository = "${bucket}/books";
          paths = [ "/mnt/external/books" ];
        };
      };
    };
}
