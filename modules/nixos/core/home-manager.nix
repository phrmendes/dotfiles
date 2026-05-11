{ inputs, config, ... }:
{
  modules.nixos.core.home-manager =
    { ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        extraSpecialArgs = {
          inherit inputs;
          inherit (config.settings) nvimServerPort;
        };
      };
    };
}
