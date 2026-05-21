_: {
  modules.nixos.server.surrealdb =
    { config, ... }:
    {
      server.homepage.services.surrealdb = {
        dataDir = "/srv/containers/surrealdb";
        monitoredServices = [ "surrealdb" ];
        homepage.enable = false;
      };

      systemd = {
        tmpfiles.rules = [ "d /srv/containers/surrealdb 0750 surrealdb surrealdb -" ];
        services.surrealdb.serviceConfig = {
          EnvironmentFile = config.age.secrets."surrealdb.env".path;
          MemoryAccounting = false;
        };
      };

      # SurrealDB must bind to 0.0.0.0 so the open-notebook podman container
      # can reach it via the podman gateway IP (settings.podman.gateway).
      # Port 8000 is not in the firewall allowlist so LAN access is blocked.
      services.surrealdb = {
        enable = true;
        dbPath = "rocksdb:/srv/containers/surrealdb/data.db";
        host = "0.0.0.0";
        port = 8000;
        extraFlags = [ "--username root" ];
      };
    };
}
