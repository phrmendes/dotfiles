{ config, inputs, ... }:
let
  inherit (config) settings;
  inherit (config.flake.modules) homeManager;
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
    ".zotero"
    "Documents"
    "Downloads"
    "Pictures"
    "Videos"
    "Zotero"
  ];
  versioning = {
    simple = {
      type = "simple";
      params = {
        keep = "10";
        cleanoutDays = "30";
      };
    };
    trashcan = {
      type = "trashcan";
      params.cleanoutDays = "15";
    };
  };
  workstations = [
    "desktop"
    "laptop"
    "server"
  ];
  allDevices = workstations ++ [
    "phone"
    "tablet"
  ];
  trashcanFolder = path: devices: {
    inherit path devices;
    versioning = versioning.trashcan;
  };
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
          fzf
          gh
          git
          gnupg
          gtk
          hyprland
          imv
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
            file = ../../secrets/pi.age.json;
            path = "${settings.home}/.pi/agent/auth.json";
          };
          "noctalia.txt" = mkSecretReadable {
            owner = settings.user;
            file = ../../secrets/noctalia.age.txt;
          };
        };

        hardware = {
          keyboard.qmk.enable = true;
          bluetooth = {
            enable = true;
            powerOnBoot = true;
            settings.Policy.AutoEnable = true;
            input.General = {
              ClassicBondedOnly = false;
              LEBondedOnly = false;
              UserspaceHID = true;
            };
          };
        };

        users.users.${settings.user}.extraGroups = [
          "adbusers"
          "audio"
          "video"
        ];

        services = {
          tailscale = {
            enable = true;
            useRoutingFeatures = "client";
          };

          resolved = {
            enable = true;
            settings.Resolve = {
              DNS = [ settings.lan.serverAddress ];
              Domains = [ "~${settings.serverDomain}" ];
              DNSSEC = "false";
              LLMNR = "false";
            };
          };

          flatpak.enable = true;
          geoclue2.enable = true;
          gvfs.enable = true;

          greetd = {
            enable = true;
            settings = rec {
              initial_session = {
                inherit (settings) user;
                command = "${lib.getExe pkgs.uwsm} start hyprland-uwsm.desktop";
              };
              default_session = initial_session;
            };
          };

          power-profiles-daemon.enable = lib.mkDefault true;
          upower.enable = true;

          pipewire = {
            enable = true;
            pulse.enable = true;
            alsa = {
              enable = true;
              support32Bit = true;
            };
          };

          syncthing = {
            inherit (settings) user;
            enable = true;
            configDir = "${settings.home}/.config/syncthing";
            openDefaultPorts = true;
            overrideDevices = true;
            overrideFolders = true;
            settings = {
              options = {
                localAnnounceEnabled = true;
                urAccepted = 1;
              };
              devices = lib.mapAttrs (_: id: { inherit id; }) settings.syncthingDevices;
              folders = {
                "documents" = trashcanFolder "${settings.home}/Documents/documents" workstations;
                "images" = trashcanFolder "${settings.home}/Pictures/images" workstations;
                "notes" = {
                  path = "${settings.home}/Documents/notes";
                  versioning = versioning.simple;
                  devices = allDevices;
                };
                "ufabc" = trashcanFolder "${settings.home}/Documents/ufabc" (workstations ++ [ "tablet" ]);
                "collections" = trashcanFolder "${settings.home}/Documents/collections" workstations;
                "excalidraw" = trashcanFolder "${settings.home}/Documents/excalidraw" workstations;
                "reading" = trashcanFolder "${settings.home}/Documents/reading" allDevices;
                "keepassxc" = trashcanFolder "${settings.home}/Documents/keepassxc" allDevices;
              };
            };
          };
        };

        programs = {
          dconf.enable = true;
          ssh = {
            startAgent = true;
            askPassword = "${pkgs.openssh-askpass}/libexec/gtk-ssh-askpass";
          };
          hyprland = {
            enable = true;
            withUWSM = true;
          };
          thunar = {
            enable = true;
            plugins = with pkgs; [ thunar-volman ];
          };
        };

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

        xdg.portal = {
          enable = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-hyprland
            xdg-desktop-portal-gtk
          ];
          config.hyprland.default = [
            "hyprland"
            "gtk"
          ];
        };
      };
    };
}
