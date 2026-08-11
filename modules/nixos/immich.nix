{
  nixosModules.immich =
    { config, ... }:
    let
      port = 2283;
    in
    {
      homepage.services.immich = {
        url = "immich.${config.caddy.domain}";
        homepage = {
          name = "Immich";
          description = "Self-hosted photo and video management";
          icon = "sh-immich";
          category = "Media";
        };
      };

      users.users.immich.extraGroups = [
        "external"
        "video"
        "render"
      ];

      systemd.tmpfiles.rules = [
        "d /mnt/external/photos 2770 immich external -"
        "d /srv/immich 0750 immich immich -"
      ];

      services = {
        caddy.virtualHosts = config.caddy.mkVhost {
          name = "immich";
          inherit port;
        };
        immich = {
          enable = true;
          host = "127.0.0.1";
          inherit port;
          mediaLocation = "/mnt/external/photos";
          accelerationDevices = null;
        };
      };
    };
}
