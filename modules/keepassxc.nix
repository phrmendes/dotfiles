_: {
  modules.homeManager.workstation.keepassxc =
    { pkgs, lib, ... }:
    let
      iniFile = ".config/keepassxc/keepassxc.ini";
      iniContent = lib.generators.toINI { } {
        General = {
          ConfigVersion = 2;
          MinimizeAfterUnlock = false;
        };
        Browser = { Enabled = true; };
        FdoSecrets = { Enabled = true; };
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
    in
    {
      home.packages = [ pkgs.keepassxc ];

      xdg.portal.config.common."org.freedesktop.impl.portal.Secret" = [ "keepassxc" ];

      programs.firefox.nativeMessagingHosts = [ pkgs.keepassxc ];

      wayland.windowManager.hyprland.settings.exec-once = [
        "${pkgs.keepassxc}/bin/keepassxc --minimized"
      ];

      home.activation.keepassxcIni =
        let
          iniDrv = pkgs.writeText "keepassxc.ini" iniContent;
        in
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          ini="$HOME/${iniFile}"
          mkdir -p "$(dirname "$ini")"
          cp ${iniDrv} "$ini"
          chmod 600 "$ini"
        '';
    };
}
