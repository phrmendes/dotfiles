{ inputs, ... }:
{
  modules.nixos.core.home-manager =
    { ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        sharedModules = [ inputs.nix-index-database.homeModules.default ];
      };
    };
}
