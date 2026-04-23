{ config, ... }:
let
  inherit (config.modules) homeManager nixos;
  commonDirs = [
    ".cache"
    ".config"
    ".docker"
    ".gnupg"
    ".kube"
    ".local"
    ".mozilla"
    ".password-store"
    ".pi"
    ".pki"
    ".ssh"
    ".zotero"
    "Documents"
    "Downloads"
    "Pictures"
    "Projects"
    "Videos"
    "Zotero"
  ];
  devModules = with homeManager.dev; [
    atuin
    bat
    btop
    direnv
    docker
    eza
    fd
    fzf
    gh
    git
    jq
    k8s
    kitty
    lazydocker
    lazygit
    neovim
    nix-index
    opencode
    packages
    pi
    ripgrep
    starship
    tealdeer
    tmux
    yazi
    zoxide
    zsh
  ];
  workstationModules = with homeManager.workstation; [
    dunst
    firefox
    flameshot
    gtk
    hyprland
    hypridle
    hyprlock
    hyprpaper
    keepassxc
    nm-applet
    packages
    swayosd
    udiskie
    vicinae
    waybar
    xdg
  ];
in
{
  modules = {
    nixos.workstation = {
      common = _: {
        imports = with nixos.workstation; [
          greetd
          hyprland
          libvirtd
          pam
          pipewire
          persistence
          xdg-portal
          syncthing
        ];
      };

      greetd =
        { pkgs, ... }:
        {
          services.greetd = {
            enable = true;
            settings = rec {
              terminal.vt = 1;
              initial_session = default_session;
              default_session = {
                command = "${pkgs.hyprland}/bin/start-hyprland";
                inherit (config.settings) user;
              };
            };
          };
        };

      pipewire = {
        services.pipewire = {
          enable = true;
          pulse.enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };
        };
      };

      xdg-portal =
        { pkgs, ... }:
        {
          xdg.portal = {
            enable = true;
            extraPortals = with pkgs; [
              xdg-desktop-portal-wlr
              xdg-desktop-portal-gtk
            ];
          };
        };

      pam = {
        security.pam.services = {
          hyprlock.gnupg.enable = true;
          login.gnupg.enable = true;
        };
      };

      libvirtd =
        { pkgs, ... }:
        {
          programs.virt-manager.enable = true;
          virtualisation.libvirtd = {
            enable = true;
            qemu = {
              package = pkgs.qemu_kvm;
              runAsRoot = true;
              swtpm.enable = true;
            };
          };
        };

      persistence = {
        environment.persistence."/persist".users.${config.settings.user}.directories = commonDirs ++ [
          {
            directory = ".keychain";
            mode = "u=rwx,go=";
          }
        ];
      };
    };

    homeManager.workstation = {
      flameshot =
        {
          pkgs,
          config,
          lib,
          ...
        }:
        {
          home.packages = [ pkgs.flameshot ];

          xdg.autostart.entries = [
            "${pkgs.flameshot}/share/applications/org.flameshot.Flameshot.desktop"
          ];

          xdg.configFile."flameshot/flameshot.ini".text = lib.generators.toINI { } {
            General = with config.lib.stylix.colors.withHashtag; {
              contrastUiColor = base0A;
              disabledGrimWarning = true;
              disabledTrayIcon = true;
              drawColor = base08;
              showAbortNotification = false;
              showDesktopNotification = false;
              showStartupLaunchMessage = false;
              uiColor = base00;
              useGrimAdapter = true;
            };
          };
        };

      gtk =
        { pkgs, ... }:
        {
          gtk = {
            enable = true;
            iconTheme = {
              name = "Pop";
              package = pkgs.pop-icon-theme;
            };
          };
        };

      nm-applet =
        { pkgs, ... }:
        {
          home.packages = [ pkgs.networkmanagerapplet ];

          xdg.autostart.entries = [
            "${pkgs.networkmanagerapplet}/etc/xdg/autostart/nm-applet.desktop"
          ];
        };

      packages =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [
            blueman
            deluge-gtk
            drawing
            exiftool
            ffmpeg
            ffmpegthumbnailer
            file-roller
            filezilla
            gcolor3
            gdu
            grim
            imagemagick
            libqalculate
            obs-studio
            onlyoffice-desktopeditors
            pandoc
            pass
            pavucontrol
            phockup
            poppler
            proton-vpn
            quarto
            stremio-linux-shell
            tectonic
            terraform
            thunar
            tpm2-tools
            ungoogled-chromium
            vesktop
            zotero
          ];
        };

      xdg = {
        xdg = {
          enable = true;
          autostart.enable = true;
          mime.enable = true;

          configFile."mimeapps.list".force = true;
          mimeApps = {
            enable = true;
            defaultApplications = {
              "audio/*" = "mpv.desktop";
              "image/*" = "imv.desktop";
              "video/*" = "mpv.desktop";
              "text/*" = "nvim.desktop";
              "text/plain" = "nvim-qt.desktop";
              "x-scheme-handler/terminal" = "kitty.desktop";
              "application/x-terminal-emulator" = "kitty.desktop";
              "application/pdf" = "org.pwmt.zathura.desktop";
            };
          };
        };
      };

      swayosd = {
        services.swayosd.enable = true;
      };

      udiskie = {
        services.udiskie = {
          enable = true;
          tray = "auto";
        };
      };

      common = _: {
        imports =
          (with homeManager.user; [
            base
            symlinks
          ])
          ++ devModules
          ++ workstationModules
          ++ (with homeManager.media; [
            imv
            mpv
            zathura
          ]);
      };
    };
  };
}
