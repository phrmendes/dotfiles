{
  config,
  lib,
  parameters,
  pkgs,
  ...
}: {
  options.waybar.enable = lib.mkEnableOption "enable waybar";

  config = lib.mkIf config.waybar.enable {
    programs.waybar = let
      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      shared = {
        date_time = {
          format = "<tt>{:%H:%M}</tt>";
          interval = 60;
          tooltip = true;
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            on-scroll = 1;
            format = with config.lib.stylix.colors.withHashtag; {
              today = ''<span color="${base08}"><b><u>{}</u></b></span>'';
              days = ''<span color="${base04}"><b>{}</b></span>'';
              weekdays = ''<span color="${base04}"><b>{}</b></span>'';
              weeks = ''<span color="${base04}"><b>W{}</b></span>'';
              months = ''<span color="${base04}"><b>{}</b></span>'';
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
        nix = {
          format = " ";
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
          output = parameters.monitors.primary;
          layer = "top";
          position = "top";
          height = 30;
          spacing = 5;
          modules-left = ["hyprland/workspaces"];
          modules-center = ["hyprland/window"];
          modules-right = [
            "hyprland/language"
            "custom/separator"
            "cpu"
            "custom/separator"
            "memory"
            "custom/separator"
            "tray"
            "custom/separator"
            "clock"
            "custom/nix"
            "custom/spacer"
          ];
          tray = {
            icon-size = 15;
            spacing = 15;
          };
          cpu = {
            interval = 10;
            format = " <tt> {}%</tt>";
            max-length = 10;
          };
          memory = {
            interval = 30;
            format = "󰘚 <tt> {}%</tt>";
            max-length = 10;
          };
          "hyprland/language" = {
            format = "󰌌 <tt> {}</tt>";
            format-en = "en-US";
            format-pt = "pt-BR";
          };
          "hyprland/window" = {
            format = " <tt> {}</tt>";
            max-length = 50;
          };
          "hyprland/workspaces" = {
            format = "<tt>{name}</tt>";
            all-outputs = true;
            active-only = false;
            on-click = "activate";
            on-scroll-up = "${hyprctl} dispatch workspace r+1";
            on-scroll-down = "${hyprctl} dispatch workspace r-1";
          };
          clock = shared.date_time;
          "custom/separator" = shared.separator;
          "custom/spacer" = shared.spacer;
          "custom/nix" = shared.nix;
        }
        {
          output = parameters.monitors.secondary;
          modules-left = ["hyprland/workspaces"];
          modules-right = [
            "clock"
            "custom/nix"
            "custom/spacer"
          ];
          clock = shared.date_time;
          "custom/separator" = shared.separator;
          "custom/spacer" = shared.spacer;
          "custom/nix" = shared.nix;
        }
      ];
    };
  };
}
