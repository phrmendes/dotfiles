_: {
  modules.homeManager.workstation.dunst =
    { osConfig, ... }:
    {
      services.dunst = {
        enable = true;
        settings = {
          global = {
            monitor = osConfig.machine.monitors.primary.name;
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
