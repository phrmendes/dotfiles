{
  flake.modules.nixos.ddclient =
    { config, ... }:
    {
      age.secrets.ddclient = config.utils.mkSecretReadable {
        file = ../../../secrets/ddclient.age.txt;
      };

      services.ddclient = {
        enable = true;
        protocol = "dyndns2";
        server = "update.dedyn.io";
        username = "wg.phrmendes.xyz";
        passwordFile = config.age.secrets.ddclient.path;
        domains = [ "wg.phrmendes.xyz" ];
        interval = "5min";
        usev6 = "disabled";
      };
    };
}
