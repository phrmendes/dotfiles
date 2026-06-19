{ config, ... }:
{
  modules.homeManager.workstation.flameshot =
    { config, ... }:
    let
      c = config.lib.stylix.colors.withHashtag;
    in
    {
      services.flameshot = {
        enable = true;
        settings.General = {
          uiColor = c.base0D;
          contrastUiColor = c.base00;
          drawColor = c.base08;
          drawThickness = 3;
          showStartupLaunchMessage = false;
          useGrimAdapter = true;
          disabledTrayIcon = true;
          savePath = "${config.home.homeDirectory}/Pictures/Screenshots";
          savePathFixed = true;
          startupLaunch = false;
          showDesktopNotification = false;
        };
      };
    };
}
