{ config, ... }:
let
  inherit (config.modules) homeManager nixos;
in
{
  modules = {
    nixos.workstation = {
      common =
        { ... }:
        {
          imports = with nixos.workstation; [
            blueman
            greetd
            hyprland
            libvirtd
            pam
            pipewire
            persistence
            secrets
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

      blueman = {
        services.blueman.enable = true;
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
        environment.persistence."/persist".users.${config.settings.user}.directories = [
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
          {
            directory = ".keychain";
            mode = "u=rwx,go=";
          }
        ];
      };
    };

    homeManager.workstation = {
      flameshot =
        { config, ... }:
        {
          services.flameshot = {
            enable = true;
            settings = {
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

      xdg = {
        xdg = {
          enable = true;
          autostart.enable = true;
          mime.enable = true;
          portal.config.common."org.freedesktop.impl.portal.Secret" = [ "keepassxc" ];
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
              "text/html" = "firefox.desktop";
              "x-scheme-handler/http" = "firefox.desktop";
              "x-scheme-handler/https" = "firefox.desktop";
              "x-scheme-handler/about" = "firefox.desktop";
              "x-scheme-handler/unknown" = "firefox.desktop";
            };
          };
        };
      };

      swayosd = {
        services.swayosd.enable = true;
      };

      blueman-applet = {
        services.blueman-applet.enable = true;
      };

      nm-applet = {
        services.network-manager-applet.enable = true;
      };

      pasystray =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [ pasystray ];
          services.pasystray.enable = true;
        };

      udiskie = {
        services.udiskie = {
          enable = true;
          tray = "auto";
        };
      };

      keepassxc =
        { pkgs, ... }:
        {
          programs.keepassxc = {
            enable = true;
            autostart = true;
            settings = {
              General = {
                ConfigVersion = 2;
                MinimizeAfterUnlock = false;
              };
              Browser.Enabled = true;
              FdoSecrets.Enabled = true;
              GUI = {
                ApplicationTheme = "dark";
                CompactMode = true;
                MinimizeOnClose = true;
                MinimizeToTray = true;
                MonospaceNotes = true;
                ShowExpiredEntriesOnDatabaseUnlockOffsetDays = 6;
                ShowTrayIcon = true;
                TrayIconAppearance = "monochrome-light";
              };
              PasswordGenerator = {
                Type = 1;
                WordCase = 2;
                WordSeparator = "-";
              };
              SSHAgent = {
                Enabled = true;
                AuthSockOverride = "/run/user/1000/ssh-agent";
              };
              Security = {
                ClearClipboardTimeout = 30;
                IconDownloadFallback = true;
              };
            };
          };
        };

      vicinae = {
        programs.vicinae = {
          enable = true;
          systemd.enable = true;
        };
      };

      common =
        { ... }:
        {
          imports =
            (with homeManager.user; [
              base
              packages
              symlinks
            ])
            ++ (with homeManager.dev; [
              atuin
              bat
              btop
              direnv
              eza
              fd
              fzf
              gh
              git
              jq
              k9s
              kitty
              lazydocker
              lazygit
              neovim
              nix-index
              opencode
              ripgrep
              starship
              tealdeer
              tmux
              yazi
              zoxide
              zsh
            ])
            ++ (with homeManager.workstation; [
              blueman-applet
              dunst
              flameshot
              gtk
              hyprland
              hypridle
              hyprlock
              hyprpaper
              keepassxc
              nm-applet
              pasystray
              swayosd
              udiskie
              vicinae
              waybar
              xdg
            ])
            ++ (with homeManager.media; [
              imv
              mpv
              zathura
            ]);
        };
    };
  };
}
