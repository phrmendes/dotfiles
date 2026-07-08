{ config, inputs, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.core.age = _: {
    imports = [ inputs.agenix.nixosModules.default ];

    age.identityPaths = [ "/persist${settings.home}/.ssh/age" ];
  };
}
