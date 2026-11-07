{
  flake.modules.nixos.restic =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      bucket = "b2:phrmendes-backups:restic";
    in
    {
      options.restic.mkBackup = lib.mkOption {
        type = lib.types.functionTo lib.types.anything;
        readOnly = true;
        description = ''
          Per-repository restic backup options. Takes the repository name and an attribute set.
          `sqlite` maps a live database to a file name under /var/backup/<name>.
        '';
        example = ''
          mkBackup "gitolite" { paths = [ "/var/lib/gitolite" ]; }
        '';
        default =
          name:
          {
            sqlite ? { },
            ...
          }@backup:
          let
            backupDir = "/var/backup/${name}";
            dump = lib.getExe pkgs.local.backup-sqlite;
            copies = lib.mapAttrsToList (database: target: "${dump} ${database} ${backupDir}/${target}") sqlite;
            sqliteBackup = lib.optionalAttrs (sqlite != { }) {
              paths = lib.unique ((backup.paths or [ ]) ++ [ backupDir ]);
              exclude = (backup.exclude or [ ]) ++ map (database: "${database}*") (lib.attrNames sqlite);
              backupPrepareCommand = lib.concatStringsSep "\n" copies;
              backupCleanupCommand = "rm -rf ${backupDir}";
            };
          in
          {
            repository = "${bucket}/${name}";
            environmentFile = config.age.secrets."restic.env".path;
            initialize = true;
            pruneOpts = [
              "--keep-daily 7"
              "--keep-weekly 4"
              "--keep-monthly 6"
            ];
            checkOpts = [ "--read-data-subset=5%" ];
            timerConfig = {
              OnCalendar = "03:00";
              RandomizedDelaySec = "30m";
              Persistent = true;
            };
          }
          // removeAttrs backup [ "sqlite" ]
          // sqliteBackup;
      };

      options.restic.restoreTests = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "databases"
          "gitolite"
        ];
        description = ''
          Backups that a monthly job restores into a temporary directory with `--verify`.
          Keep this list to small repositories, because a restore downloads the data.
        '';
      };

      config =
        let
          tests = lib.filter (name: config.services.restic.backups ? ${name}) config.restic.restoreTests;
        in
        {
          age.secrets."restic.env" = config.utils.mkSecretReadable {
            file = ../../../secrets/restic.age.env;
          };

          systemd.services = lib.mapAttrs' (
            name: _:
            lib.nameValuePair "restic-restore-test-${name}" {
              description = "Restore the latest ${name} backup and verify it";
              wants = [ "network-online.target" ];
              after = [ "network-online.target" ];
              path = [
                pkgs.coreutils
                config.system.path
              ];
              serviceConfig = {
                Type = "oneshot";
                Nice = 19;
                IOSchedulingClass = "idle";
                ExecStart = "${lib.getExe pkgs.local.restic-restore-test} ${name} /var/tmp";
              };
            }
          ) (lib.genAttrs tests (_: { }));

          systemd.timers = lib.mapAttrs' (
            name: _:
            lib.nameValuePair "restic-restore-test-${name}" {
              wantedBy = [ "timers.target" ];
              timerConfig = {
                OnCalendar = "monthly";
                Persistent = true;
                RandomizedDelaySec = "2h";
                Unit = "restic-restore-test-${name}.service";
              };
            }
          ) (lib.genAttrs tests (_: { }));
        };
    };
}
