_: {
  modules.nixos.server.immich =
    { config, ... }:
    let
      port = 2283;
    in
    {
      server.homepage.services.immich = {
        url = "immich.${config.server.caddy.domain}";
        monitoredServices = [ "immich-server" ];
        homepage = {
          name = "Immich";
          description = "Self-hosted photo and video management";
          icon = "sh-immich";
          category = "Media";
        };
      };

      services.caddy.virtualHosts = config.server.caddy.mkVhost "immich" port;

      users.users.immich.extraGroups = [
        "external"
        "video"
        "render"
      ];

      systemd.tmpfiles.rules = [
        "d /mnt/external/photos 2775 ${config.settings.user} external -"
        "d /srv/immich 0750 immich immich -"
      ];

      services.immich = {
        enable = true;
        host = "127.0.0.1";
        inherit port;
        mediaLocation = "/mnt/external/photos";
        accelerationDevices = null;
      };
    };
}
