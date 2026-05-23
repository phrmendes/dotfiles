{ inputs, config, ... }:
let
  flakeConfig = config;
in
{
  modules.nixos.core.home-manager =
    { config, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        extraSpecialArgs = {
          inherit inputs;
          dotfilesDir = config.machine.dotfilesDir;
          inherit (flakeConfig.settings) nvimServerPort;
          inherit (flakeConfig) dotfilesLib;
        };
      };
    };
}
