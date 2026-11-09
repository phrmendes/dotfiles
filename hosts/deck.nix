{ config, inputs, ... }:
let
  settings = config.const;
  inherit (config.flake.modules) homeManager;
in
{
  flake.homeConfigurations.deck = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.${config.hostPlatform};

    modules = [
      (
        { pkgs, ... }:
        {
          imports = [ inputs.stylix.homeModules.stylix ];

          stylix = {
            enable = true;
            autoEnable = false;
            enableReleaseChecks = false;
            base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
            polarity = "dark";
            targets.zellij.enable = true;
          };
        }
      )
      {
        nixpkgs = {
          config.allowUnfree = true;
          overlays = [ config.flake.overlays.local ];
        };
        home = {
          username = "deck";
          homeDirectory = "/home/deck";
          inherit (settings) stateVersion;
        };
        targets.genericLinux.enable = true;
      }
    ]
    ++ (with homeManager; [
      bat
      carapace
      direnv
      fd
      git
      neovim
      nushell
      ripgrep
      starship
      yazi
      zellij
    ]);
  };
}
