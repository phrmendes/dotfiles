{ config, inputs, ... }:
let
  inherit (config) settings dotfilesLib;
in
{
  modules.nixos.core.age =
    _:
    let
      secretReadable = args: dotfilesLib.mkSecretReadable ({ user = settings.user; } // args);
    in
    {
      imports = [ inputs.agenix.nixosModules.default ];
      age = {
        identityPaths = [ "/persist${settings.home}/.ssh/age" ];
        secrets = {
          "pi.json" = secretReadable {
            file = ../../../secrets/pi.age.json;
            path = "${settings.home}/.pi/agent/auth.json";
          };
        };
      };
    };
}
