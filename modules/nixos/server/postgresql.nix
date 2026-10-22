{
  flake.modules.nixos.postgresql =
    { config, ... }:
    {
      services = {
        postgresqlBackup = {
          enable = true;
          databases = config.services.postgresql.ensureDatabases;
        };
        restic.backups.databases = config.restic.mkBackup "databases" {
          paths = [ config.services.postgresqlBackup.location ];
        };
      };
    };
}
