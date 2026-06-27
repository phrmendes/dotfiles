{ inputs, ... }:
{
  modules.homeManager.workstation.noctalia =
    {
      pkgs,
      config,
      lib,
      osConfig,
      ...
    }:
    let
      c = config.lib.stylix.colors.withHashtag;
      inherit (osConfig.machine) isLaptop;
      inherit (osConfig.machine.monitors) secondary;
      barMonitorOverrides =
        if secondary != null then
          {
            secondary = {
              match = secondary.name;
              enabled = false;
            };
          }
        else
          { };
    in
    {
      imports = [ inputs.noctalia.homeModules.default ];

      stylix.targets.qt.enable = lib.mkForce false;

      programs.noctalia = {
        enable = true;
        systemd.enable = false;

        settings = {
          theme = {
            mode = "dark";
            source = "custom";
            custom_palette = "stylix";
          };

          shell = {
            font_family = config.stylix.fonts.sansSerif.name;
            corner_radius_scale = 0.2;
            time_format = "{:%H:%M %a, %b %d}";
            date_format = "%A, %x";
            clipboard_enabled = true;
            clipboard_auto_paste = "auto";
            settings_show_advanced = false;
            polkit_agent = false;
            telemetry_enabled = false;
            shared_gl_context = true;
            animation = {
              enabled = true;
              speed = 1.0;
            };
            shadow = {
              direction = "down";
              alpha = 0.55;
            };
            panel = {
              transparency_mode = "solid";
              borders = true;
              shadow = true;
              launcher_placement = "centered";
              clipboard_placement = "centered";
              control_center_placement = "attached";
              wallpaper_placement = "attached";
              session_placement = "attached";
            };
          };

          bar.main = {
            position = "top";
            thickness = 34;
            background_opacity = 0.93;
            widget_spacing = 10;
            margin_ends = 0;
            margin_edge = 0;
            padding = 8;
            radius = 0;
            capsule = false;
            shadow = true;
            start = [
              "control-center"
              "active_window"
            ];
            center = [ "workspaces" ];
            end = [
              "tray"
              "caffeine"
              "sysmon"
              "volume"
              "battery"
              "clock"
            ];
          };

          bar.main.monitor = barMonitorOverrides;

          widget.clock = {
            format = "{:%H:%M %a, %b %d}";
            vertical_format = "{:%H\n%M}";
            tooltip_format = "{:%H:%M %a, %b %d}";
          };

          widget.control-center = {
            custom_image = "/run/current-system/sw/share/icons/hicolor/128x128/apps/nix-snowflake.png";
          };

          wallpaper = {
            enabled = true;
            fill_mode = "crop";
            directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
          };

          notification = {
            enable_daemon = true;
            background_opacity = 0.97;
            offset_x = 20;
            offset_y = 8;
          };

          dock.enabled = false;

          lockscreen = {
            enabled = true;
            blurred_desktop = true;
            blur_intensity = 0.5;
            tint_intensity = 0.3;
          };

          backdrop = {
            enabled = true;
            blur_intensity = 0.5;
            tint_intensity = 0.3;
          };

          idle.behavior.lock = {
            timeout = 660;
            command = "noctalia:session lock";
            enabled = true;
          };
          idle.behavior.screen-off = {
            timeout = 600;
            command = "noctalia:dpms-off";
            resume_command = "noctalia:dpms-on";
            enabled = true;
          };

          nightlight = {
            enabled = true;
            temperature_day = 6500;
            temperature_night = 4000;
          };

          location = {
            auto_locate = false;
            address = "São Paulo";
          };
          weather = {
            enabled = true;
            effects = true;
            unit = "celsius";
          };

          system.monitor.enabled = true;
          desktop_widgets.enabled = false;

          control_center.shortcuts = [
            { type = "bluetooth"; }
            { type = "caffeine"; }
            { type = "nightlight"; }
            { type = "notification"; }
            { type = "power_profile"; }
          ]
          ++ lib.optional isLaptop { type = "wifi"; };
        };

        customPalettes =
          let
            stylixPalette = {
              primary = c.base0D;
              onPrimary = c.base00;
              secondary = c.base0C;
              onSecondary = c.base00;
              tertiary = c.base0E;
              onTertiary = c.base00;
              error = c.base08;
              onError = c.base00;
              surface = c.base00;
              onSurface = c.base05;
              surfaceVariant = c.base01;
              onSurfaceVariant = c.base04;
              outline = c.base03;
              shadow = c.base00;
              hover = c.base01;
              onHover = c.base06;
            };
            ansiColors = {
              black = c.base00;
              red = c.base08;
              green = c.base0B;
              yellow = c.base0A;
              blue = c.base0D;
              magenta = c.base0E;
              cyan = c.base0C;
              white = c.base05;
            };
            terminalSection = {
              normal = ansiColors;
              bright = ansiColors // {
                black = c.base03;
                red = c.base09;
                green = c.base0B;
                yellow = c.base0A;
                blue = c.base0D;
                magenta = c.base0F;
                cyan = c.base0C;
                white = c.base07;
              };
              foreground = c.base05;
              background = c.base00;
              cursor = c.base05;
              cursorText = c.base00;
              selectionFg = c.base00;
              selectionBg = c.base0D;
            };
            modeWithTerminal = stylixPalette // {
              terminal = terminalSection;
            };
          in
          {
            stylix = {
              dark = modeWithTerminal;
            };
          };
      };

      systemd.user.services.noctalia = {
        Unit = {
          Description = "Noctalia - A lightweight Wayland shell and bar";
          PartOf = [ config.wayland.systemd.target ];
          After = [
            config.wayland.systemd.target
            "wayland-wm@hyprland-uwsm.desktop.service"
          ];
          X-Restart-Triggers = lib.optional (
            config.programs.noctalia.settings != { }
          ) "${config.xdg.configFile."noctalia/config.toml".source}";
        };
        Service = {
          ExecStart = lib.getExe inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
          Restart = "on-failure";
          RestartSec = 3;
        };
        Install.WantedBy = [ config.wayland.systemd.target ];
      };
    };
}
