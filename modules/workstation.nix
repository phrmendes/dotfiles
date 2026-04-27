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
    cliphist
    firefox
    gtk
    hyprland
    keepassxc
    noctalia
    packages
    udiskie
    xdg
  ];
in
{
  modules = {
    nixos.workstation = {
      common = _: {
        imports = with nixos.workstation; [
          ly
          hyprland
          libvirtd
          noctalia
          pam
          pipewire
          persistence
          xdg-portal
          syncthing
        ];
      };

      ly = {
        environment.binsh = "/run/current-system/sw/bin/bash";
        services.displayManager.ly = {
          enable = true;
          settings.animation = "matrix";
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
              name = "Papirus-Dark";
              package = pkgs.papirus-icon-theme;
            };
          };
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
            grim
            satty
            slurp
            tesseract
            vesktop
            wl-clipboard
            wf-recorder
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
