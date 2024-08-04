{
  lib,
  config,
  parameters,
  ...
}: {
  options.dunst.enable = lib.mkEnableOption "enable dunst";

  config = lib.mkIf config.dunst.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          monitor = parameters.monitors.primary;
          corner_radius = 5;
          frame_width = 0;
          gap_size = 2;
          hide_duplicate_count = true;
          notification_limit = 5;
          offset = "20x20";
        };
      };
    };
  };
}
