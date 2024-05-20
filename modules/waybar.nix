{
  config,
  lib,
  ...
}: {
  options.waybar.enable = lib.mkEnableOption "enable waybar";

  config = lib.mkIf config.waybar.enable {
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
      settings = {
        mainBar = {
          output = "HDMI-A-1";
          layer = "top";
          position = "top";
          height = 30;
          spacing = 15;
          modules-left = ["hyprland/workspaces"];
          modules-center = ["clock"];
          modules-right = [
            "hyprland/language"
            "cpu"
            "memory"
            "pulseaudio#input"
            "pulseaudio#output"
            "tray"
          ];
          tray = {
            icon-size = 15;
            spacing = 15;
          };
          cpu = {
            interval = 10;
            format = "<tt> {}%</tt>";
            max-length = 10;
          };
          memory = {
            interval = 30;
            format = "<tt>󰘚 {}%</tt>";
            max-length = 10;
          };
          clock = {
            format = "<tt> {:%H:%M}</tt>";
            interval = 60;
            tooltip = true;
            tooltip-format = "<tt>{:%A, %d %B %Y (%R)}</tt>";
          };
          "hyprland/workspaces" = {
            format = "<tt>{name}</tt>";
            format-window-separator = "|";
            all-outputs = true;
            on-click = "activate";
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
            persistent-workspaces = {
              "HDMI-A-1" = 9;
            };
          };
          "hyprland/language" = {
            format = "<tt>󰌌 {}</tt>";
            format-en = "English (US)";
            format-br = "Portuguese (BR)";
          };
          "pulseaudio#input" = {
            format-source = "<tt>󰍬 {volume}%</tt>";
            format-source-muted = "<tt>󰍭  (muted)</tt>";
            format = "<tt>{format_source}</tt>";
            scroll-step = 1;
            smooth-scrolling-threshold = 1;
            max-volume = 100;
            on-click = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            on-click-middle = "pavucontrol";
            on-scroll-up = "pactl set-source-volume @DEFAULT_SOURCE@ +1%";
            on-scroll-down = "pactl set-source-volume @DEFAULT_SOURCE@ -1%";
          };
          "pulseaudio#output" = {
            format = "<tt>{icon} {volume}%</tt>";
            format-muted = "<tt>󰝟 (muted)</tt>";
            max-volume = 100;
            scroll-step = 2;
            smooth-scrolling-threshold = 1;
            on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
            on-click-middle = "pavucontrol";
            format-icons = {
              default = ["󰕿" "󰖀" "󰕾"];
            };
          };
        };
      };
    };
  };
}
