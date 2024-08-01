{
  lib,
  config,
  ...
}: {
  options.dunst.enable = lib.mkEnableOption "enable dunst";

  config = lib.mkIf config.dunst.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          corner_radius = 5;
          frame_width = 0;
          gap_size = 2;
          hide_duplicate_count = true;
          monitor = "HDMI-A-1";
          notification_limit = 5;
          offset = "20x20";
        };
      };
    };
  };
}
