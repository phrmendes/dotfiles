{ config, inputs, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.core.home-manager = _: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
      extraSpecialArgs = { inherit inputs; };
    };
  };

  modules.homeManager.user.base =
    { lib, ... }:
    {
      imports = [ inputs.nix-index-database.homeModules.default ];

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks."*".addKeysToAgent = "no";
      };

      home = {
        stateVersion = "26.05";
        username = settings.user;
        homeDirectory = settings.home;
        sessionVariables = {
          EDITOR = lib.mkOverride 1001 "nvim";
          GIT_EDITOR = lib.mkOverride 1001 "nvim";
          SUDO_EDITOR = lib.mkOverride 1001 "nvim";
          VISUAL = lib.mkOverride 1001 "nvim";
        };
      };
    };
}
