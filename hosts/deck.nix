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
            enableReleaseChecks = false;
            base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
            polarity = "dark";
          };
        }
      )
      ({ pkgs, ... }: {
        nixpkgs = {
          config.allowUnfree = true;
          overlays = [ config.flake.overlays.local ];
        };
        home = {
          inherit (settings) stateVersion;
          username = "deck";
          homeDirectory = "/home/deck";
          packages = [ pkgs.moonlight-qt ];
          file.".config/plasma-workspace/env/nix.sh".text = ''
            export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"
            export XDG_DATA_DIRS="$HOME/.nix-profile/share:/nix/var/nix/profiles/default/share:''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
          '';
        };
        services.syncthing = {
          overrideDevices = false;
          overrideFolders = false;
        };
        targets.genericLinux.enable = true;
      })
    ]
    ++ (with homeManager; [
      atuin
      bat
      carapace
      devenv
      difftastic
      direnv
      fd
      fzf
      gaming
      gh
      git
      gitolite
      gnupg
      k8s
      keepassxc
      kitty
      librewolf
      lua
      neovim
      nh
      nushell
      pi
      ripgrep
      sharedPackages
      shell
      ssh
      starship
      syncthing
      tealdeer
      vivid
      yazi
      zoxide
    ]);
  };
}
