{pkgs, ...}: {
  services.dunst = let
    colors = import ../../shared/catppuccin.nix;
  in {
    enable = true;
    iconTheme = {
      name = "Pop";
      package = pkgs.pop-icon-theme;
    };
    settings = with colors.catppuccin.palette; {
      global = {
        font = "Fira Sans 12";
        format = "<b>%s</b>\\n%b";
        frame_color = "${blue}";
        frame_width = 1;
        fullscreen = "pushback";
        hide_duplicate_count = true;
        history_length = 15;
        horizontal_padding = 6;
        icon_position = "left";
        line_height = 3;
        markup = "full";
        max_icon_size = 80;
        offset = "0x0";
        origin = "top-right";
        padding = 6;
        separator_color = "frame";
        show_age_threshold = -1;
        sort = false;
        width = 384;
        word_wrap = true;
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
}
