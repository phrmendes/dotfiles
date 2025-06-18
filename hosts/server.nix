{
  config,
  lib,
  parameters,
  ...
}:
let
  glances_port = toString config.services.glances.port;
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
in
{
  imports = [ ./shared ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;
  networking.hostName = "server";
  programs.nh.flake = "/home/${parameters.user}/dotfiles";

  services = {
    glances.enable = true;
    duplicati.enable = true;
    sftpgo.enable = true;

    adguardhome = {
      enable = true;
      mutableSettings = true;
      openFirewall = true;
      port = 80;
    };

    homepage-dashboard = {
      enable = true;
      widgets = [
        {
          "Info" = {
            widget = {
              type = "glances";
              url = "http://localhost:${glances_port}";
              metric = "info";
              version = 4;
              chart = false;
            };
          };
        }
        {
          "Processes" = {
            widget = {
              type = "glances";
              url = "http://localhost:${glances_port}";
              metric = "process";
              version = 4;
            };
          };
        }
        {
          "Network" = {
            widget = {
              type = "glances";
              url = "http://localhost:${glances_port}";
              metric = "network:enp3s0";
              version = 4;
            };
          };
        }
      ];
    };

    tailscale = {
      useRoutingFeatures = "both";
      extraSetFlags = [
        "--exit-node"
        "--advertise-exit-node"
      ];
    };

    syncthing.settings.folders = {
      "camera" = {
        path = "${parameters.home}/Syncthing/camera";
        versioning = versioning.trashcan;
        devices = [
          "server"
          "phone"
        ];
      };
      "documents" = {
        path = "${parameters.home}/Syncthing/documents";
        versioning = versioning.trashcan;
        devices = [ "server" ];
      };
      "images" = {
        path = "${parameters.home}/Syncthing/images";
        versioning = versioning.trashcan;
        devices = [ "server" ];
      };
      "notes" = {
        path = "${parameters.home}/Syncthing/notes";
        versioning = versioning.simple;
        devices = [
          "server"
          "phone"
          "tablet"
        ];
      };
      "ufabc" = {
        path = "${parameters.home}/Syncthing/ufabc";
        versioning = versioning.trashcan;
        devices = [ "server" ];
      };
      "comics" = {
        path = "${parameters.home}/Syncthing/library/comics";
        versioning = versioning.trashcan;
        devices = [ "server" ];
      };
      "IT" = {
        path = "${parameters.home}/Syncthing/library/IT";
        versioning = versioning.trashcan;
        devices = [ "server" ];
      };
      "math" = {
        path = "${parameters.home}/Syncthing/library/math";
        versioning = versioning.trashcan;
        devices = [ "server" ];
      };
      "social_sciences" = {
        path = "${parameters.home}/Syncthing/library/social_sciences";
        versioning = versioning.trashcan;
        devices = [ "server" ];
      };
      "zotero" = {
        path = "${parameters.home}/Syncthing/library/zotero";
        versioning = versioning.trashcan;
        devices = [
          "server"
          "tablet"
        ];
      };
      "collections" = {
        path = "${parameters.home}/Syncthing/collections";
        versioning = versioning.trashcan;
        devices = [ "server" ];
      };
      "keepassxc" = {
        path = "${parameters.home}/Syncthing/keepassxc";
        versioning = versioning.trashcan;
        devices = [
          "server"
          "phone"
        ];
      };
    };

    caddy = {
      enable = true;
      virtualHosts = {
        ${parameters.homelab_domain} = {
          extraConfig = "reverse_proxy localhost:${toString config.services.homepage-dashboard.listenPort}";
        };
        "syncthing.${parameters.homelab_domain}" = {
          extraConfig = "reverse_proxy ${config.services.syncthing.guiAddress}";
        };
        "duplicati.${parameters.homelab_domain}" = {
          extraConfig = "reverse_proxy localhost:${toString config.services.duplicati.port}";
        };
        "adguardhome.${parameters.homelab_domain}" = {
          extraConfig = "reverse_proxy localhost:${toString config.services.adguardhome.port}";
        };
        "sftpgo.${parameters.homelab_domain}" = {
          extraConfig = "reverse_proxy localhost:8080";
        };
      };
    };
  };

  home-manager.users.${parameters.user} = {
    blueman-applet.enable = false;
    cliphist.enable = false;
    direnv.enable = false;
    dunst.enable = false;
    gh.enable = false;
    gtk-settings.enable = false;
    hypridle.enable = false;
    hyprland.enable = false;
    hyprlock.enable = false;
    hyprpaper.enable = false;
    imv.enable = false;
    k9s.enable = false;
    keepassxc.enable = false;
    lazydocker.enable = false;
    lazygit.enable = false;
    mpv.enable = false;
    neovim.enable = false;
    nm-applet.enable = false;
    packages.enable = false;
    pasystray.enable = false;
    screenshot.enable = false;
    swayosd.enable = false;
    symlinks.enable = false;
    syncthingtray.enable = false;
    tealdeer.enable = false;
    udiskie.enable = false;
    uv.enable = false;
    waybar.enable = false;
    wofi.enable = false;
    zathura.enable = false;
  };

  environment.persistence."/persist".users.${parameters.user}.directories = [
    "Syncthing"
    ".config"
    ".ssh"
    ".zotero"
    ".local/share"
    ".local/state"
  ];
}
