{
  nixosModules.restic =
    { config, lib, ... }:
    let
      bucket = "b2:phrmendes-backups:restic";
    in
    {
      options.restic.mkBackup = lib.mkOption {
        type = lib.types.anything;
        readOnly = true;
        default =
          name: backup:
          {
            repository = "${bucket}/${name}";
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
          }
          // backup;
      };
    };
}
