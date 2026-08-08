{ config, ... }:
let
  inherit (config.settings) user home;
in
{
  modules.nixos.workstation.age =
    { config, ... }:
    let
      inherit (config.dotfilesLib) mkSecretReadable;
    in
    {
      age.secrets."pi.json" = mkSecretReadable {
        inherit user;
        file = ../../../secrets/pi.age.json;
        path = "${home}/.pi/agent/auth.json";
      };
    };
}
