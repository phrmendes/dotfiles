{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.gtk-settings.enable = lib.mkEnableOption "enable gtk settings";

  config = lib.mkIf config.gtk-settings.enable {
    gtk = {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };
  };
}
