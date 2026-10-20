{
  nixosModules.ddclient =
    { config, lib, ... }:
    {
      users = {
        users.ddclient = {
          isSystemUser = true;
          group = "ddclient";
        };
        groups.ddclient = { };
      };

      systemd.services.ddclient.serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = "ddclient";
        Group = "ddclient";
      };

      services.ddclient = {
        enable = true;
        protocol = "dyndns2";
        server = "update.dedyn.io";
        username = "phrmendes.xyz";
        domains = [ "vpn.phrmendes.xyz" ];
        passwordFile = config.age.secrets."ddclient.token".path;
        interval = "5min";
        ssl = true;
        quiet = true;
      };
    };
}
