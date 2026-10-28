{ config, inputs, ... }:
let
  inherit (config) settings;
  inherit (config.flake.modules) homeManager nixos;
  commonDirs = [
    ".ansible"
    ".cache/helm"
    ".cache/helmfile"
    ".cache/keepassxc"
    ".cache/noctalia"
    ".config"
    ".docker"
    ".kube"
    ".local/share/atuin"
    ".local/share/direnv"
    ".local/share/helm"
    ".local/share/k9s"
    ".local/share/keyrings"
    ".local/share/mods"
    ".local/share/neovide"
    ".local/share/nix"
    ".local/share/nvim"
    ".local/share/uv"
    ".local/share/zathura"
    ".local/share/zoxide"
    ".local/share/nushell"
    ".local/state/comma"
    ".local/state/home-manager"
    ".local/state/keepassxc"
    ".local/state/nix"
    ".local/state/noctalia"
    ".local/state/nvim"
    ".local/state/wireplumber"
    ".pi"
    ".ssh"
    ".var/app"
    ".zotero"
    "Documents"
    "Downloads"
    "Pictures"
    "Videos"
    "Zotero"
  ];
in
{
  flake.modules.nixos.workstation =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.utils) mkSecretReadable;

      monitor = {
        options = {
          name = lib.mkOption { type = lib.types.str; };
          resolution = lib.mkOption { type = lib.types.str; };
          position = lib.mkOption { type = lib.types.str; };
          refreshRate = lib.mkOption { type = lib.types.int; };
          scale = lib.mkOption { type = lib.types.float; };
        };
      };
    in
    {
      imports = with nixos; [
        audio
        bluetooth
        core
        disko
        flatpak
        podman
        resolved
        session
        syncthingWorkstation
        tailscale
      ];

      options.workstation = lib.mkOption {
        type = lib.types.submodule {
          options = {
            type = lib.mkOption {
              type = lib.types.enum [
                "desktop"
                "laptop"
              ];
            };
            dotfilesDir = lib.mkOption {
              type = lib.types.path;
              default = "${settings.home}/.config/dotfiles";
            };
            monitors = lib.mkOption {
              type = lib.types.submodule {
                options = {
                  primary = lib.mkOption { type = lib.types.submodule monitor; };
                  secondary = lib.mkOption {
                    type = lib.types.nullOr (lib.types.submodule monitor);
                    default = null;
                  };
                };
              };
            };
          };
        };
      };

      config = {
        programs.nh.flake = config.workstation.dotfilesDir;

        home-manager.users.${settings.user}.imports = with homeManager; [
          atuin
          gitolite
          base
          bat
          btop
          devenv
          difftastic
          direnv
          fd
          flameshot
          gh
          git
          gnupg
          gtk
          hyprland
          jq
          jujutsu
          k8s
          keepassxc
          kitty
          librewolf
          lua
          mpv
          neovim
          nix-index
          noctalia
          nushell
          packages
          pi
          ripgrep
          symlinks
          tealdeer
          tmux
          xdg
          yazi
          zathura
          zoxide
        ];

        age.secrets = {
          "pi.json" = mkSecretReadable {
            owner = settings.user;
            file = ../../../secrets/pi.age.json;
            path = "${settings.home}/.pi/agent/auth.json";
          };
          "noctalia.txt" = mkSecretReadable {
            owner = settings.user;
            file = ../../../secrets/noctalia.age.txt;
          };
        };

        hardware.keyboard.qmk.enable = true;

        users.users.${settings.user}.extraGroups = [
          "adbusers"
          "audio"
          "video"
        ];

        environment = {
          persistence."/persist".users.${settings.user}.directories = commonDirs ++ [
            {
              directory = ".gnupg";
              mode = "0700";
            }
            {
              directory = ".keychain";
              mode = "u=rwx,go=";
            }
          ];
          systemPackages = with pkgs; [
            egl-wayland
            gcc
            gnumake
            inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
            libsecret
            p7zip
            python314
            rar
            unar
            xdg-utils
          ];
        };
      };
    };
}
