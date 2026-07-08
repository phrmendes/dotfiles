{ config, ... }:
{
  modules.nixos.workstation.age =
    _:
    let
      inherit (config.dotfilesLib) mkSecretReadable;
    in
    {
      age.secrets."pi.json" = mkSecretReadable {
        user = config.settings.user;
        file = ../../../secrets/pi.age.json;
        path = "${config.settings.home}/.pi/agent/auth.json";
      };
    };
}
