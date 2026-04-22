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
      maxLength = 40;
      sharedWidgets = [
        "clock"
        "cpu"
        "idle_inhibitor"
        "memory"
        "pulseaudio"
        "bluetooth"
        "tray"
        "battery"
        "backlight"
      ];
      primaryModulesRight = [
        "hyprland/language"
        "custom/separator"
        "idle_inhibitor"
        "custom/separator"
        "cpu"
        "custom/separator"
        "memory"
        "custom/separator"
        "pulseaudio"
        "custom/separator"
        "bluetooth"
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
      format =
        {
          icon,
          content ? "",
        }:
        "<span font_size='12288' rise='-1024' letter_spacing='2048'>${icon}</span>${
          lib.optionalString (content != "") " "
        }${content}";
      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      widgets = {
        backlight = {
          tooltip = true;
          tooltip-format = "Brightness: {percent}%";
          format = format {
            icon = "{icon}";
            content = "{percent}%";
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
            content = "{capacity}%";
          };
          format-charging = format {
            icon = "";
            content = "{capacity}%";
          };
          format-full = format {
            icon = "";
            content = "Charged";
          };
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        bluetooth = {
          format = format { icon = "󰂯"; };
          format-connected = format {
            icon = "󰂱";
            content = "{device_alias}";
          };
          format-disabled = format { icon = "󰂲"; };
          format-off = format { icon = "󰂲"; };
          format-no-controller = format { icon = "󰂲"; };
          tooltip = true;
          tooltip-format = "Status: {status}\nConnected: {num_connections}";
          on-click = "blueman-manager";
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
          tooltip = true;
          tooltip-format = "CPU usage: {usage}%";
          format = format {
            icon = "";
            content = "{usage}%";
          };
        };
        idle_inhibitor = {
          format = "<span font='12'>{icon}</span> ";
          tooltip = false;
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        language = {
          tooltip = false;
          format = "{}";
          format-en = "en-US";
          format-pt = "pt-BR";
        };
        memory = {
          interval = 30;
          tooltip = true;
          tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G ({percentage}%)";
          format = format {
            icon = "󰘚";
            content = "{percentage}%";
          };
        };
        pulseaudio = {
          tooltip = true;
          tooltip-format = "{desc}\nVolume: {volume}%";
          tooltip-format-muted = "{desc}\nVolume: {volume}% (muted)";
          format = format { icon = "{icon}"; };
          format-muted = format {
            icon = "󰝟";
          };
          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          on-click = "pavucontrol";
        };
        nix = {
          format = format { icon = " "; };
          tooltip = false;
          min-length = 3;
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
          max-length = maxLength;
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
          (
            {
              output = monitors.primary.name;
              layer = "top";
              position = "top";
              height = 30;
              spacing = 5;
              modules-left = [ "hyprland/workspaces" ];
              modules-center = [ "hyprland/window" ];
              modules-right = primaryModulesRight;
              "custom/nix" = widgets.nix;
              "custom/separator" = widgets.separator;
              "custom/spacer" = widgets.spacer;
              "hyprland/language" = widgets.language;
              "hyprland/window" = widgets.window;
              "hyprland/workspaces" = widgets.workspaces;
            }
            // (lib.getAttrs sharedWidgets widgets)
          )
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
