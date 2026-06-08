_: {
  modules.nixos.server.qdrant =
    { lib, ... }:
    {
      users = {
        groups.qdrant = { };
        users.qdrant = {
          isSystemUser = true;
          group = "qdrant";
        };
      };

      systemd = {
        services.qdrant.serviceConfig = {
          DynamicUser = lib.mkForce false;
          User = lib.mkForce "qdrant";
          Group = lib.mkForce "qdrant";
          WorkingDirectory = "/srv/qdrant";
        };
        tmpfiles.rules = [ "d /srv/qdrant 0750 qdrant qdrant -" ];
      };

      services.qdrant = {
        enable = true;
        settings = {
          service.host = "127.0.0.1";
          storage.storage_path = lib.mkForce "/srv/qdrant/storage";
          storage.snapshots_path = lib.mkForce "/srv/qdrant/snapshots";
          telemetry_disabled = true;
        };
      };
    };
}
