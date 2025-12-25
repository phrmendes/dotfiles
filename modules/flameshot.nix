{
  lib,
  config,
  ...
}:
{
  options.flameshot.enable = lib.mkEnableOption "enable flameshot";

  config = lib.mkIf config.flameshot.enable {
    services.flameshot = {
      enable = true;
      settings = {
        General = with config.lib.stylix.colors.withHashtag; {
          contrastUiColor = base0A;
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
}
