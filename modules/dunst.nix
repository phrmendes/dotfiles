{
  pkgs,
  lib,
  config,
  ...
}: {
  options.dunst.enable = lib.mkEnableOption "enable dunst";

  config = lib.mkIf config.dunst.enable {
    services.dunst = let
      colors = import ./catppuccin.nix;
    in {
      enable = true;
      iconTheme = {
        name = "Pop";
        package = pkgs.pop-icon-theme;
      };
      settings = with colors.catppuccin.palette; {
        global = {
          corner_radius = 5;
          font = "Fira Sans 12";
          frame_width = 0;
          gap_size = 2;
          hide_duplicate_count = true;
          monitor = "HDMI-A-1";
          notification_limit = 5;
          offset = "20x20";
          progress_bar = true;
          separator_color = "foreground";
          sort = true;
        };
        urgency_low = {
          background = "#${surface0}";
          foreground = "#${text}";
        };
        urgency_normal = {
          background = "#${surface0}";
          foreground = "#${text}";
        };
        urgency_critical = {
          background = "#${surface0}";
          foreground = "#${text}";
          frame_color = "#${peach}";
        };
      };
    };
  };
}
