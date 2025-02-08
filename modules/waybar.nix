{
  config,
  lib,
  parameters,
  pkgs,
  ...
}:
{
  options.waybar.enable = lib.mkEnableOption "enable waybar";
  config = lib.mkIf config.waybar.enable {
    programs.waybar =
      let
        tt = text: "<tt>${text}</tt>";
        hyprctl = "${pkgs.hyprland}/bin/hyprctl";
        modules = {
          backlight = {
            format = "{icon}  " + tt "{percent}%";
            format-icons = [
              ""
              ""
            ];
          };
          battery = {
            interval = 60;
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon}  " + tt "{capacity}%";
            format-charching = "  " + tt "{capacity}%";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
            max-length = 25;
          };
          clock = {
            format = tt "{:%H:%M}";
            interval = 60;
            tooltip = true;
            tooltip-format = tt "<small>{calendar}</small>";
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
          cpu = {
            interval = 10;
            format = "  " + tt "{}%";
            max-length = 10;
          };
          idle_inhibitor = {
            format = "{icon} ";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
          language = {
            format = "󰌌  " + tt "{}";
            format-en = "en-US";
            format-pt = "pt-BR";
          };
          memory = {
            interval = 30;
            format = "󰘚  " + tt "{}%";
            max-length = 10;
          };
          nix = {
            format = " ";
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
          tray = {
            icon-size = 15;
            spacing = 15;
          };
          window = {
            format = "  " + tt "{}";
            max-length = 25;
          };
          workspaces = {
            format = tt "{name}";
            all-outputs = true;
            active-only = false;
            on-click = "activate";
            on-scroll-up = "${hyprctl} dispatch workspace r+1";
            on-scroll-down = "${hyprctl} dispatch workspace r-1";
          };
        };
      in
      {
        enable = true;
        systemd = {
          enable = true;
          target = "hyprland-session.target";
        };
        settings = with parameters; [
          {
            output = monitors.primary;
            layer = "top";
            position = "top";
            height = 30;
            spacing = 5;
            modules-left = [ "hyprland/workspaces" ];
            modules-center = [ "hyprland/window" ];
            modules-right = [
              "idle_inhibitor"
              "custom/separator"
              "hyprland/language"
              "custom/separator"
              "cpu"
              "custom/separator"
              "memory"
              "custom/separator"
              (lib.mkIf laptop "backlight")
              (lib.mkIf laptop "custom/separator")
              (lib.mkIf laptop "battery")
              (lib.mkIf laptop "custom/separator")
              "tray"
              "custom/separator"
              "clock"
              "custom/nix"
              "custom/spacer"
            ];
            "custom/nix" = modules.nix;
            "custom/separator" = modules.separator;
            "custom/spacer" = modules.spacer;
            "hyprland/language" = modules.language;
            "hyprland/window" = modules.window;
            "hyprland/workspaces" = modules.workspaces;
            clock = modules.clock;
            cpu = modules.cpu;
            idle_inhibitor = modules.idle_inhibitor;
            memory = modules.memory;
            tray = modules.tray;
            battery = modules.battery;
            backlight = modules.backlight;
          }
          (lib.mkIf (!laptop) {
            output = monitors.secondary;
            layer = "top";
            position = "top";
            height = 30;
            spacing = 5;
            modules-left = [ "hyprland/workspaces" ];
            modules-right = [
              "custom/nix"
              "custom/spacer"
            ];
            "custom/nix" = modules.nix;
            "custom/spacer" = modules.spacer;
            "hyprland/workspaces" = modules.workspaces;
          })
        ];
      };
  };
}
