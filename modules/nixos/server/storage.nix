{
  flake.modules.nixos.storage =
    { config, ... }:
    {
      services.restic.backups = {
        zotero = config.restic.mkBackup "zotero" { paths = [ "/mnt/external/zotero" ]; };
        calibre = config.restic.mkBackup "calibre" { paths = [ "/mnt/external/calibre/library" ]; };
      };

      externalDisk.directories = [
        { path = "zotero"; }
        { path = "movies"; }
        { path = "tvshows"; }
        { path = "downloads"; }
        {
          path = "downloads/.incomplete";
          owner = "transmission";
          mode = "2770";
        }
        { path = "comics"; }
      ];
    };
}
