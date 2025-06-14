{
  lib,
  config,
  ...
}:
{
  options.keepassxc.enable = lib.mkEnableOption "enable keepassxc";

  config = lib.mkIf config.keepassxc.enable {
    programs.keepassxc = {
      enable = true;
      settings = {
        Browser.Enabled = true;
        FdoSecrets.Enabled = true;
        SSHAgent.Enabled = true;
        SSHAgent.AuthSockOverride = "/run/user/1000/ssh-agent";
        General = {
          ConfigVersion = 2;
          MinimizeAfterUnlock = false;
        };
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
        Security = {
          ClearClipboardTimeout = 30;
          IconDownloadFallback = true;
        };
      };
    };
  };
}
