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
          output = ["HDMI-A-1" "DP-1"];
          layer = "top";
          position = "top";
          height = 30;
          spacing = 5;
          modules-left = ["hyprland/workspaces"];
          modules-center = ["hyprland/window"];
          modules-right = [
            "idle_inhibitor"
            "custom/separator"
            "hyprland/language"
            "custom/separator"
            "cpu"
            "custom/separator"
            "memory"
            "custom/separator"
            "pulseaudio#input"
            "custom/separator"
            "pulseaudio#output"
            "custom/separator"
            "tray"
            "custom/separator"
            "clock"
            "custom/spacer"
          ];
          tray = {
            icon-size = 15;
            spacing = 15;
          };
          cpu = {
            interval = 10;
            format = "<tt>  {}%</tt>";
            max-length = 10;
          };
          memory = {
            interval = 30;
            format = "󰘚<tt>  {}%</tt>";
            max-length = 10;
          };
          clock = {
            format = "<tt>{:%H:%M}</tt>";
            interval = 60;
            tooltip = true;
            tooltip-format = "{:%A, %d %b %Y}";
          };
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
              tooltip-format-activated = "Active";
              tooltip-format-deactivated = "Inactive";
            };
          };
          "custom/separator" = {
            format = "";
            interval = "once";
            tooltip = false;
          };
          "custom/spacer" = {
            format = " ";
            interval = "once";
            tooltip = false;
          };
          "hyprland/language" = {
            format = "󰌌<tt>  {}</tt>";
            format-en = "en-US";
            format-pt = "pt-BR";
          };
          "hyprland/window" = {
            format = "<tt>  {}</tt>";
            max-length = 50;
          };
          "hyprland/workspaces" = {
            format = "<tt>{name}</tt>";
            all-outputs = true;
            on-click = "activate";
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
            persistent-workspaces = {
              "HDMI-A-1" = 9;
            };
          };
          "pulseaudio#input" = {
            format-source = "󰍬<tt>  {volume}%</tt>";
            format-source-muted = "󰍭<tt>  (muted)</tt>";
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
            format = "{icon}<tt>  {volume}%</tt>";
            format-muted = "󰝟<tt>  (muted)</tt>";
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
