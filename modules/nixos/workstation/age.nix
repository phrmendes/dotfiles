{ config, ... }:
let
  inherit (config) dotfilesLib settings;
in
{
  modules.nixos.workstation.age = {
    age.secrets."pi.json" = dotfilesLib.mkSecretReadable {
      user = settings.user;
      file = ../../../secrets/pi.age.json;
      path = "${settings.home}/.pi/agent/auth.json";
    };
  };
}
