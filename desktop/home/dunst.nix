{pkgs, ...}: {
  services.dunst = let
    colors = import ../../shared/catppuccin.nix;
  in {
    enable = true;
    iconTheme = {
      name = "Pop";
      package = pkgs.pop-icon-theme;
    };
    settings = with colors.catppuccin.pallete; {
      font = "Fira Sans";
      markup = "full";
      format = "<b>%s</b>\\n%b";
      sort = false;
      alignment = "center";
      show_age_threshold = -1;
      word_wrap = true;
      hide_duplicate_count = true;
      width = 384;
      origin = "bottom-right";
      offset = "0x0";
      history_length = 15;
      line_height = 3;
      padding = 6;
      horizontal_padding = 6;
      separator_color = "frame";
      icon_position = "left";
      max_icon_size = 80;
      frame_width = 1;
      fullscreen = "pushback";
      global = {
        frame_color = "${blue}";
        separator_color = "frame";
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
