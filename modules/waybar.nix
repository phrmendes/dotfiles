{
  config,
  lib,
  ...
}: {
  options.waybar.enable = lib.mkEnableOption "enable waybar";

  config = lib.mkIf config.waybar.enable {
    programs.waybar = let
      shared = {
        date_time = {
          format = "<tt>  {:%H:%M}</tt>";
          interval = 60;
          tooltip = true;
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            on-scroll = 1;
            format = {
              months = ''<span color="#${config.lib.stylix.colors.base04}"><b>{}</b></span>'';
              days = ''<span color="#${config.lib.stylix.colors.base04}"><b>{}</b></span>'';
              weeks = ''<span color="#${config.lib.stylix.colors.base04}"><b>W{}</b></span>'';
              weekdays = ''<span color="#${config.lib.stylix.colors.base04}"><b>{}</b></span>'';
              today = ''<span color="#${config.lib.stylix.colors.base08}"><b><u>{}</u></b></span>'';
            };
          };
          actions = {
            on-scroll-up = "shift_down";
            on-scroll-down = "shift_up";
          };
        };
        separator = {
          format = "";
          interval = "once";
          tooltip = false;
        };
        spacer = {
          format = " ";
          interval = "once";
          tooltip = false;
        };
      };
    in {
      enable = true;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
      settings = [
        {
          output = "HDMI-A-1";
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
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
              tooltip-format-activated = "Active";
              tooltip-format-deactivated = "Inactive";
            };
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
            active-only = false;
            on-click = "activate";
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
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
          clock = shared.date_time;
          "custom/separator" = shared.separator;
          "custom/spacer" = shared.spacer;
        }
        {
          output = "DP-1";
          modules-left = ["hyprland/workspaces"];
          modules-right = [
            "clock"
            "custom/spacer"
          ];
          clock = shared.date_time;
          "custom/separator" = shared.separator;
          "custom/spacer" = shared.spacer;
        }
      ];
    };
  };
}
