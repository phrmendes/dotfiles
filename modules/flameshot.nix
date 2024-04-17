{
  config,
  lib,
  pkgs,
  ...
}: {
  options.flameshot.enable = lib.mkEnableOption "enable flameshot";

  config = lib.mkIf config.flameshot.enable {
    services.flameshot = let
      colors = import ./catppuccin.nix;
    in {
      enable = true;
      settings = {
        General = with colors.catppuccin.hex; {
          contrastUiColor = yellow;
          disabledTrayIcon = true;
          showDesktopNotification = false;
          showHelp = false;
          showStartupLaunchMessage = false;
          uiColor = base;
        };
      };
    };
  };
}
