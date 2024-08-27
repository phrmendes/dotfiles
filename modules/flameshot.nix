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
        General = with config.lib.stylix.colors.withHashtag; {
          contrastUiColor = "${base09}";
          drawColor = "${base08}";
          uiColor = "${base00}";
        };
      };
    };
  };
}
