{
  nixosModules.atuin =
    { config, ... }:
    let
      port = 8888;
    in
    {
      homepage.services.atuin = {
        dataDir = "/var/lib/atuin";
        url = "atuin.${config.caddy.domain}";
        homepage = {
          name = "Atuin";
          description = "Shell history sync";
          icon = "sh-atuin";
          category = "Services";
        };
      };

      services = {
        caddy.virtualHosts = config.caddy.mkVhost {
          name = "atuin";
          inherit port;
        };
        atuin = {
          database = {
            createLocally = false;
            uri = "sqlite:///var/lib/atuin/atuin.db";
          };
          enable = true;
          host = "127.0.0.1";
          openRegistration = false;
          port = port;
        };
      };

      systemd.services.atuin.serviceConfig.StateDirectory = "atuin";
    };
}
