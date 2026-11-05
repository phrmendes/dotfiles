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

      systemd.services.postgresql-collation-refresh = {
        description = "Rebuild PostgreSQL objects after a collation update";
        after = [ "postgresql.service" ];
        requires = [ "postgresql.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          User = "postgres";
        };
        script = ''
          psql=${config.services.postgresql.package}/bin/psql
          "$psql" --tuples-only --no-align postgres <<'SQL' | while IFS= read -r database; do
          SELECT datname
          FROM pg_database
          WHERE datallowconn
            AND datcollversion IS DISTINCT FROM pg_database_collation_actual_version(oid);
          SQL
            printf 'REINDEX DATABASE :"database";\nALTER DATABASE :"database" REFRESH COLLATION VERSION;\n' \
              | "$psql" --set="database=$database" "$database"
          done
        '';
      };
    };
}
