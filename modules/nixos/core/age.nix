{ config, inputs, ... }:
let
  inherit (config) settings dotfilesLib;
in
{
  modules.nixos.core.age =
    _:
    let
      secretReadable = dotfilesLib.mkSecretReadable settings.user;
    in
    {
      imports = [ inputs.agenix.nixosModules.default ];
      age = {
        identityPaths = [ "/persist${settings.home}/.ssh/age" ];
        secrets = {
          "bifrost.env" = secretReadable ../../../secrets/bifrost.age.env;
          "bifrost.txt" = secretReadable ../../../secrets/bifrost.age.txt;
          "opencode.txt" = secretReadable ../../../secrets/opencode.age.txt;
          "vertex.json" = secretReadable ../../../secrets/vertex.age.json;
        };
      };
    };
}
