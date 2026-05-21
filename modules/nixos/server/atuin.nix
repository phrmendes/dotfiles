_: {
  modules.nixos.server.atuin =
    { config, ... }:
    let
      port = 8888;
    in
    {
      server.homepage.services.atuin = {
        dataDir = "/var/lib/atuin";
        url = "atuin.${config.server.caddy.domain}";
        monitoredServices = [ "atuin" ];
        homepage = {
          name = "Atuin";
          description = "Shell history sync";
          icon = "sh-atuin";
          category = "Services";
        };
      };

      services.caddy.virtualHosts = config.server.caddy.mkVhost "atuin" port;

      services.atuin = {
        enable = true;
        host = "127.0.0.1";
        inherit port;
        openRegistration = false;
        database = {
          createLocally = false;
          uri = "sqlite:///var/lib/atuin/atuin.db";
        };
      };

      systemd.services.atuin.serviceConfig.StateDirectory = "atuin";
    };
}
