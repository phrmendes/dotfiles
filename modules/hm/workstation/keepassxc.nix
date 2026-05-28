_: {
  modules.homeManager.workstation.keepassxc =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      configDir = ".config/keepassxc";
      localStateDir = ".local/state/keepassxc";
      ini = pkgs.writeText "keepassxc.ini" (
        lib.generators.toINI { } {
          General = {
            ConfigVersion = 2;
            MinimizeAfterUnlock = false;
          };
          Browser.Enabled = true;
          FdoSecrets = {
            ConfirmAccessItem = false;
            ConfirmDeleteItem = false;
            Enabled = true;
            NoConfirmAccessEnabled = true;
          };
          GUI = {
            ApplicationTheme = "dark";
            CompactMode = true;
            MinimizeOnClose = true;
            MinimizeOnStartup = true;
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
          SSHAgent.Enabled = true;
          Security = {
            ClearClipboardTimeout = 30;
            IconDownloadFallback = true;
            LockDatabaseIdle = false;
          };
        }
      );

      localIni = pkgs.writeText "keepassxc-local.ini" (
        lib.generators.toINI { } {
          SSHAgent = {
            AuthSockOverride = "/run/user/%U/ssh-agent";
            SecurityKeyProviderOverride = "";
          };
        }
      );
    in
    {
      home.packages = [ pkgs.keepassxc ];

      systemd.user.services.keepassxc = {
        Unit = {
          Description = "KeePassXC password manager";
          PartOf = [ config.wayland.systemd.target ];
          After = [
            config.wayland.systemd.target
            "noctalia-shell.service"
          ];
        };
        Service = {
          ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
          Restart = "on-failure";
          RestartSec = 5;
        };
        Install.WantedBy = [ config.wayland.systemd.target ];
      };

      xdg.portal.config = {
        common."org.freedesktop.impl.portal.Secret" = [ "keepassxc" ];
        hyprland.default = [
          "hyprland"
          "gtk"
        ];
      };

      home.activation.keepassxcConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p "$HOME/${configDir}"
        $DRY_RUN_CMD mkdir -p "$HOME/${localStateDir}"
        $DRY_RUN_CMD install -m 600 ${ini} "$HOME/${configDir}/keepassxc.ini"
        $DRY_RUN_CMD install -m 600 ${localIni} "$HOME/${localStateDir}/keepassxc.ini"
      '';
    };
}
