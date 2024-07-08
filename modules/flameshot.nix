{
  lib,
  config,
  ...
}: {
  options.flameshot.enable = lib.mkEnableOption "enable flameshot";

  config = lib.mkIf config.flameshot.enable {
    services.flameshot = {
      enable = true;
      settings = {
        General = {
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
          uiColor = "#${config.lib.stylix.colors.base00}";
          contrastUiColor = "#${config.lib.stylix.colors.base0A}";
        };
      };
    };
  };
}
