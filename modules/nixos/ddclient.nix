{ config, ... }:
let
  inherit (config) settings;
in
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
        username = settings.publicDomain;
        domains = [ "vpn.${settings.publicDomain}" ];
        passwordFile = config.age.secrets."ddclient.token".path;
        interval = "5min";
        ssl = true;
        quiet = true;
        usev6 = "";
      };
    };
}
