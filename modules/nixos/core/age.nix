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
          "claude-service-account.json" = secretReadable ../../../secrets/claude-service-account.age.json;
          "deepseek.txt" = secretReadable ../../../secrets/deepseek.age.txt;
          "opencode.txt" = secretReadable ../../../secrets/opencode.age.txt;
        };
      };
    };
}
