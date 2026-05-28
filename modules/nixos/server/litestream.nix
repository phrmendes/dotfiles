_: {
  modules.nixos.server.litestream =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      dbs = [
        {
          path = "/srv/containers/linkding/db.sqlite3";
          name = "linkding";
        }
        {
          path = "/var/lib/atuin/atuin.db";
          name = "atuin";
        }
        {
          path = "/srv/beszel/beszel_data/data.db";
          name = "beszel";
        }
        {
          path = "/srv/sftpgo/sftpgo.db";
          name = "sftpgo";
        }
        {
          path = "/srv/sonarr/sonarr.db";
          name = "sonarr";
        }
        {
          path = "/srv/radarr/radarr.db";
          name = "radarr";
        }
        {
          path = "/var/lib/prowlarr/prowlarr.db";
          name = "prowlarr";
        }
        {
          path = "/srv/bazarr/db/bazarr.db";
          name = "bazarr";
        }
        {
          path = "/srv/duplicati/Duplicati-server.sqlite";
          name = "duplicati";
        }
      ];
      dbsJson =
        dbs |> map ({ name, path }: lib.nameValuePair name path) |> lib.listToAttrs |> builtins.toJSON;
    in
    {
      environment.systemPackages = [
        (pkgs.writeShellApplication {
          name = "litestream-restore";
          runtimeInputs = [ pkgs.jq ];
          excludeShellChecks = [ "SC1091" ];
          text = ''
            service="$1"

            db_path=$(jq -r --arg s "$service" '.[$s]' <<< '${dbsJson}')
            if [[ -z "$db_path" || "$db_path" == "null" ]]; then
              echo "Unknown service: $service"
              exit 1
            fi

            echo "Restoring $service from B2 to $db_path ..."
            systemctl stop "$service" 2>/dev/null || true
            rm -f "$db_path"
            set -a; source ${config.age.secrets."litestream.env".path}; set +a
            exec litestream restore "$db_path"
          '';
        })
      ];

      services.litestream = {
        enable = true;
        environmentFile = config.age.secrets."litestream.env".path;
        settings.dbs =
          dbs
          |> map (
            { path, name }:
            {
              inherit path;
              replicas = [
                {
                  type = "s3";
                  bucket = "phrmendes-backups";
                  path = "db/${name}";
                  endpoint = "$LITESTREAM_ENDPOINT";
                  "access-key-id" = "$LITESTREAM_ACCESS_KEY_ID";
                  "secret-access-key" = "$LITESTREAM_SECRET_ACCESS_KEY";
                }
              ];
            }
          );
      };

      systemd.services.litestream.serviceConfig.User = lib.mkForce "root";
    };
}
