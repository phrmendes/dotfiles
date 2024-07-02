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
        name = "Mint";
        package = pkgs.cinnamon.mint-y-icons;
      };
    };
  };
}
