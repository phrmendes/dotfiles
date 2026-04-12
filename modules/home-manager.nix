{ config, inputs, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.core.home-manager = _: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
      extraSpecialArgs = { inherit inputs; };
    };
  };

  modules.homeManager.user.base = {
    imports = [ inputs.nix-index-database.homeModules.default ];

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*".addKeysToAgent = "yes";
    };

    home = {
      stateVersion = "26.05";
      username = settings.user;
      homeDirectory = settings.home;
      sessionVariables = {
        EDITOR = "nvim";
        GIT_EDITOR = "nvim";
        SUDO_EDITOR = "nvim";
        VISUAL = "nvim";

      };
    };
  };
}
