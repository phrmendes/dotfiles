{ config, ... }:
let
  settings = config.const;
  inherit (config.flake.modules) homeManager nixos;
  commonDirs = [
    ".ansible"
    ".cache/helm"
    ".cache/zellij"
    ".config"
    ".docker"
    ".kube"
    ".local/bin"
    ".local/share/atuin"
    ".local/share/direnv"
    ".local/share/helm"
    ".local/share/k9s"
    ".local/share/keyrings"
    ".local/share/nix"
    ".local/share/nvim"
    ".local/share/uv"
    ".local/share/zathura"
    ".local/share/zellij"
    ".local/share/zoxide"
    ".local/share/nushell"
    ".local/state/home-manager"
    ".local/state/keepassxc"
    ".local/state/nix"
    ".local/state/noctalia"
    ".local/state/nvim"
    ".local/state/wireplumber"
    ".pi"
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
          x = lib.mkOption { type = lib.types.int; };
          y = lib.mkOption { type = lib.types.int; };
          refreshRate = lib.mkOption { type = lib.types.int; };
          scale = lib.mkOption { type = lib.types.float; };
        };
      };
    in
    {
      imports = with nixos; [
        angrr
        audio
        bluetooth
        core
        direnv
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
        security = {
          sudo.wheelNeedsPassword = true;
          pam.sshAgentAuth.enable = true;
        };

        systemd.services.dotfiles-check = {
          description = "Evaluate the dotfiles flake";
          serviceConfig = {
            Type = "oneshot";
            User = settings.user;
            WorkingDirectory = "${settings.home}/.config/dotfiles";
          };
          path = [ pkgs.nix ];
          script = "nix flake check --no-build";
        };

        systemd.timers.dotfiles-check = {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "weekly";
            Persistent = true;
            RandomizedDelaySec = "3h";
          };
        };

        home-manager.users.${settings.user}.imports = with homeManager; [
          atuin
          gitolite
          base
          bat
          carapace
          devenv
          difftastic
          fd
          gh
          git
          gnupg
          gtk
          niri
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
          starship
          symlinks
          tealdeer
          vivid
          xdg
          yazi
          zathura
          zellij
          zoxide
        ];

        age.secrets = {
          "pi.json" = mkSecretReadable {
            owner = settings.user;
            file = ../../../secrets/laptop/pi.age.json;
            path = "${settings.home}/.pi/agent/auth.json";
          };
          "noctalia.txt" = mkSecretReadable {
            owner = settings.user;
            file = ../../../secrets/laptop/noctalia.age.txt;
          };
        };

        hardware.keyboard.qmk.enable = true;

        users.users.${settings.user}.extraGroups = [
          "adbusers"
          "audio"
          "video"
        ];

        environment = {
          persistence."/persist".users.${settings.user}.directories =
            commonDirs
            ++ lib.optional (config.workstation.type == "laptop") "Projects"
            ++ [
              {
                directory = ".gnupg";
                mode = "0700";
              }
              {
                directory = ".keychain";
                mode = "u=rwx,go=";
              }
            ];
          sessionVariables.PROJECTS_DIR =
            if config.workstation.type == "desktop" then
              "/mnt/external/projects"
            else
              "${settings.home}/Projects";
          systemPackages = with pkgs; [
            egl-wayland
            gcc
            gnumake
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
