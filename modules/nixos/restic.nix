{
  nixosModules.restic =
    { config, ... }:
    let
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
          repository = "b2:phrmendes-backups:restic/photos";
          paths = [
            "/mnt/external/photos/backups"
            "/mnt/external/photos/library"
          ];
        };
        syncthing = common // {
          repository = "b2:phrmendes-backups:restic/syncthing";
          paths = [ "/mnt/external/syncthing" ];
          exclude = [
            "/mnt/external/syncthing/reading"
            "/mnt/external/syncthing/files"
          ];
        };
        zotero = common // {
          repository = "b2:phrmendes-backups:restic/zotero";
          paths = [ "/mnt/external/zotero" ];
        };
        books = common // {
          repository = "b2:phrmendes-backups:restic/books";
          paths = [ "/mnt/external/books" ];
        };
      };
    };
}
