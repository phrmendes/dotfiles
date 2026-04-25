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
    ripgrep
    starship
    tealdeer
    tmux
    yazi
    zoxide
    zsh
  ];
  workstationModules = with homeManager.workstation; [
    blueman
    dunst
    firefox
    gtk
    hypridle
    hyprland
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
        let
          startScript = pkgs.writeShellScript "start-hyprland" ''
            sleep 3
            exec ${pkgs.hyprland}/bin/Hyprland
          '';
        in
        {
          services.greetd = {
            enable = true;
            settings = {
              terminal.vt = 1;
              default_session = {
                command = "${startScript}";
                user = config.settings.user;
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
              xdg-desktop-portal-hyprland
              xdg-desktop-portal-gtk
            ];
            config.hyprland.default = [
              "hyprland"
              "gtk"
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

      blueman =
        { pkgs, ... }:
        {
          home.packages = [ pkgs.blueman ];

          xdg.autostart.entries = [
            "${pkgs.blueman}/etc/xdg/autostart/blueman-applet.desktop"
          ];
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
            satty
            slurp
            stremio-linux-shell
            tectonic
            terraform
            thunar
            tpm2-tools
            ungoogled-chromium
            vesktop
            wl-clipboard
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
