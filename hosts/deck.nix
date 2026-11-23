{ config, inputs, ... }:
let
  settings = config.const;
  inherit (config.flake.modules) homeManager;
  deckPkgs = inputs.nixpkgs.legacyPackages.${config.hostPlatform};
  caBundle = deckPkgs.cacert.override { extraCertificateFiles = [ ../files/ca.crt ]; };
  caFile = "${caBundle}/etc/ssl/certs/ca-bundle.crt";
in
{
  flake.homeConfigurations.deck = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = deckPkgs;
    modules = [
      ({ lib, pkgs, ... }: {
        imports = with inputs; [
          stylix.homeModules.stylix
          agenix.homeManagerModules.default
        ];

        options.home.file = lib.mkOption {
          type = lib.types.attrsOf (lib.types.submodule { config.force = lib.mkForce true; });
        };

        config = {
          stylix = {
            enable = true;
            enableReleaseChecks = false;
            base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
            polarity = "dark";
          };

          nixpkgs = {
            config.allowUnfree = true;
            overlays = [ config.flake.overlays.local ];
          };

          home = {
            inherit (settings) stateVersion;
            username = "deck";
            homeDirectory = "/home/deck";
            packages = [ pkgs.moonlight-qt ];
            sessionVariables.SSL_CERT_FILE = caFile;
            file.".config/plasma-workspace/env/nix.sh".text = ''
              export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"
              export XDG_DATA_DIRS="$HOME/.nix-profile/share:/nix/var/nix/profiles/default/share:''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
            '';
          };

          age.identityPaths = [ "/home/deck/.ssh/age" ];
          age.secrets."pi.json" = {
            file = ../secrets/pi.age.json;
            path = "/home/deck/.pi/agent/auth.json";
            mode = "0600";
            symlink = false;
          };

          systemd.user.sessionVariables.SSL_CERT_FILE = caFile;

          services.syncthing = {
            overrideDevices = false;
            overrideFolders = false;
          };

          programs.kitty.settings.hide_window_decorations = lib.mkForce "no";
          programs.starship.enableBashIntegration = false;
          xdg.systemDirs.config = [ "/etc/xdg" ];
          targets.genericLinux.enable = true;
        };
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
