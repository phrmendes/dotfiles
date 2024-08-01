{
  config,
  lib,
  ...
}: {
  options.flameshot.enable = lib.mkEnableOption "enable flameshot";

  config = lib.mkIf config.flameshot.enable {
    services.flameshot = {
      enable = true;
      settings = {
        contrastUiColor = "#${config.lib.stylix.colors.base09}";
        drawColor = "#${config.lib.stylix.colors.base08}";
        uiColor = "#${config.lib.stylix.colors.base00}";
      };
    };
  };
}
