_: {
  modules.homeManager.workstation.keepassxc =
    { pkgs, lib, ... }:
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
            AuthSockOverride = "/run/user/1000/ssh-agent";
            SecurityKeyProviderOverride = "";
          };
        }
      );
    in
    {
      home.packages = [ pkgs.keepassxc ];

      xdg.configFile."autostart/org.keepassxc.KeePassXC.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=KeePassXC
        Hidden=true
        X-GNOME-Autostart-enabled=false
      '';

      xdg.portal.config.common."org.freedesktop.impl.portal.Secret" = [ "keepassxc" ];
      xdg.portal.config.hyprland.default = [
        "hyprland"
        "gtk"
      ];

      systemd.user.services.keepassxc = {
        Unit = {
          Description = "KeePassXC";
          After = [
            "graphical-session.target"
            "tray.target"
          ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
          ExecStart = "${pkgs.keepassxc}/bin/keepassxc --minimized";
          Environment = [ "SSH_AUTH_SOCK=%t/ssh-agent" ];
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      home.activation.keepassxcConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p "$HOME/${configDir}"
        $DRY_RUN_CMD mkdir -p "$HOME/${localStateDir}"

        $DRY_RUN_CMD install -m 600 ${ini} "$HOME/${configDir}/keepassxc.ini"
        $DRY_RUN_CMD install -m 600 ${localIni} "$HOME/${localStateDir}/keepassxc.ini"
      '';
    };
}
