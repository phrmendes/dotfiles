_: {
  modules.homeManager.workstation.waybar =
    {
      pkgs,
      lib,
      config,
      osConfig,
      ...
    }:
    let
      isLaptop = osConfig.machine.type == "laptop";
      inherit (osConfig.machine) monitors;
      format =
        {
          icon,
          content ? "",
        }:
        "<span font='12'>${icon} </span>${content}";
      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      widgets = {
        backlight = {
          tooltip = false;
          format = format {
            icon = "{icon}";
            content = " {percent}%";
          };
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };
        battery = {
          interval = 1;
          states = {
            good = 90;
            warning = 30;
            critical = 15;
          };
          format = format {
            icon = "{icon}";
            content = " {capacity}%";
          };
          format-charging = format {
            icon = "";
            content = " {capacity}%";
          };
          format-full = format {
            icon = "";
            content = " Charged";
          };
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
          format = "{:%H:%M}";
          interval = 60;
          tooltip = true;
          tooltip-format = "<span font='12'><tt><small>{calendar}</small></tt></span>";
          calendar = {
            mode = "month";
            on-scroll = 1;
            format = with config.lib.stylix.colors.withHashtag; {
              today = "<span color='${base08}'><b><u>{}</u></b></span>";
              days = "<span color='${base04}'><b>{}</b></span>";
              weekdays = "<span color='${base04}'><b>{}</b></span>";
              weeks = "<span color='${base04}'><b>W{}</b></span>";
              months = "<span color='${base04}'><b>{}</b></span>";
            };
          };
          actions = {
            on-scroll-up = "shift_down";
            on-scroll-down = "shift_up";
          };
        };
        cpu = {
          interval = 10;
          format = format {
            icon = "";
            content = " {usage}%";
          };
          max-length = 10;
        };
        idle_inhibitor = {
          format = format { icon = "{icon}"; };
          tooltip = false;
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        language = {
          format = format {
            icon = "󰌌";
            content = " {}";
          };
          format-en = "en-US";
          format-pt = "pt-BR";
        };
        memory = {
          interval = 30;
          format = format {
            icon = "󰘚";
            content = " {percentage}%";
          };
          max-length = 10;
        };
        nix = {
          format = format { icon = ""; };
          tooltip = false;
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
          format = "{title}";
          max-length = 25;
        };
        workspaces = {
          format = "{name}";
          all-outputs = true;
          active-only = false;
          on-click = "activate";
          on-scroll-up = "${hyprctl} dispatch workspace r+1";
          on-scroll-down = "${hyprctl} dispatch workspace r-1";
        };
      };
    in
    {
      programs.waybar = {
        enable = true;
        systemd = {
          enable = true;
          targets = [ "hyprland-session.target" ];
        };
        settings = [
          {
            output = monitors.primary.name;
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
              (lib.mkIf isLaptop "backlight")
              (lib.mkIf isLaptop "custom/separator")
              (lib.mkIf isLaptop "battery")
              (lib.mkIf isLaptop "custom/separator")
              "tray"
              "custom/separator"
              "clock"
              "custom/nix"
              "custom/spacer"
            ];
            "custom/nix" = widgets.nix;
            "custom/separator" = widgets.separator;
            "custom/spacer" = widgets.spacer;
            "hyprland/language" = widgets.language;
            "hyprland/window" = widgets.window;
            "hyprland/workspaces" = widgets.workspaces;
            inherit (widgets)
              clock
              cpu
              idle_inhibitor
              memory
              tray
              battery
              backlight
              ;
          }
          (lib.mkIf (monitors.secondary != null) {
            output = monitors.secondary.name;
            layer = "top";
            position = "top";
            height = 30;
            spacing = 5;
            modules-left = [ "hyprland/workspaces" ];
            modules-right = [
              "custom/nix"
              "custom/spacer"
            ];
            "custom/nix" = widgets.nix;
            "custom/spacer" = widgets.spacer;
            "hyprland/workspaces" = widgets.workspaces;
          })
        ];
      };

      qt.platformTheme.name = lib.mkForce "adwaita";
    };
}
