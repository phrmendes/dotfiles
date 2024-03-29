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
          frame_color = "${blue}";
          hide_duplicate_count = true;
          monitor = "HDMI-A-1";
          notification_limit = 5;
          offset = "20x20";
          progress_bar = true;
          sort = true;
          gap_size = 2;
        };
        urgency_low = {
          background = "#${base}";
          foreground = "#${text}";
        };
        urgency_normal = {
          background = "#${base}";
          foreground = "#${text}";
        };
        urgency_critical = {
          background = "#${base}";
          foreground = "#${text}";
          frame_color = "#${peach}";
        };
      };
    };
  };
}
