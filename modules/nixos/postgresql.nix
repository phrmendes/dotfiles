{
  flake.modules.nixos.postgresql =
    { config, lib, ... }:
    {
      services = {
        postgresqlBackup = {
          enable = true;
          databases =
            config.services.postgresql.ensureDatabases
            |> lib.filter (
              name:
              !(lib.hasSuffix "_log" name)
              && !(lib.elem name [
                "immich"
                "miniflux"
              ])
            );
        };
        restic.backups.databases = config.restic.mkBackup "databases" {
          paths = [ config.services.postgresqlBackup.location ];
        };
      };
    };
}
