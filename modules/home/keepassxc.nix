{
  homeModules.keepassxc =
    {
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
            ShowNotification = false;
            ConfirmAccessItem = false;
            ConfirmDeleteItem = false;
            Enabled = true;
            NoConfirmAccessEnabled = true;
          };
          GUI = {
            ApplicationTheme = "dark";
            CompactMode = true;
            MinimizeOnClose = true;
            MinimizeOnStartup = false;
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

      keepassxcAutostart = pkgs.writeShellScript "keepassxc-autostart" ''
        while ! ${pkgs.systemd}/bin/busctl --user --quiet status org.kde.StatusNotifierWatcher >/dev/null 2>&1; do
          ${pkgs.coreutils}/bin/sleep 0.1
        done
        exec ${lib.getExe pkgs.keepassxc}
      '';
    in
    {
      home.packages = [ pkgs.keepassxc ];

      home.file.".config/autostart/org.keepassxc.KeePassXC.desktop" = {
        force = true;
        text = ''
          [Desktop Entry]
          Name=KeePassXC
          GenericName=Password Manager
          Exec=${keepassxcAutostart}
          TryExec=${keepassxcAutostart}
          Icon=keepassxc
          StartupWMClass=keepassxc
          StartupNotify=false
          Terminal=false
          Type=Application
          Version=1.0
          Categories=Utility;Security;Qt;
          X-GNOME-Autostart-enabled=true
        '';
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
