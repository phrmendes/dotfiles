{ config, inputs, ... }:
let
  settings = config.const;
  inherit (config.flake.modules) homeManager;
in
{
  flake.homeConfigurations.deck = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.${config.hostPlatform};

    modules = [
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
