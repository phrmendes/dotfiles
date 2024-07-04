{
  config,
  lib,
  pkgs,
  ...
}: {
  options.gtk-manager.enable = lib.mkEnableOption "enable gtk manager";

  config = lib.mkIf config.gtk-manager.enable {
    gtk = {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
      };
    };
  };
}
