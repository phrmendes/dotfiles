{
  flake.modules.homeManager.niri =
    {
      config,
      lib,
      osConfig,
      ...
    }:
    let
      inherit (osConfig.workstation) monitors;
      inherit (config.lib.stylix) colors;
      inherit (osConfig) utils;
      isLaptop = osConfig.workstation.type == "laptop";
      inherit (osConfig.stylix) cursor;
      outputs = map utils.mkOutput (
        [ monitors.primary ] ++ lib.optional (monitors.secondary != null) monitors.secondary
      );
    in
    {
      wayland.windowManager.niri = {
        enable = true;
        settings = {
          cursor = {
            xcursor-theme = cursor.name;
            xcursor-size = cursor.size;
          };
          input = {
            keyboard = {
              xkb = {
                layout = if isLaptop then "br,us" else "us,br";
                model = "pc104";
                rules = "evdev";
                options = "grp:alt_space_toggle";
              };
              numlock = { };
            };
            touchpad = {
              tap = { };
              natural-scroll = { };
            };
            focus-follows-mouse._props.max-scroll-amount = "0%";
          };

          screenshot-path = "/tmp/niri-screenshot.png";

          layout = {
            gaps = 4;
            center-focused-column = "never";
            default-column-width = {
              proportion = 1.0;
            };
            preset-column-widths._children = [
              { proportion = 1.0; }
              { proportion = 0.5; }
              { proportion = 0.33333; }
            ];
            border = {
              on = { };
              width = 1;
              active-color = "#${colors.base0F}";
              inactive-color = "#${colors.base03}";
            };
            focus-ring.off = { };
            background-color = "#${colors.base00}";
            shadow = {
              on = { };
              softness = 4;
              spread = 0;
              offset._props = {
                x = 0;
                y = 4;
              };
              color = "#${colors.base00}cc";
            };
          };
          _children = outputs;
        };
        extraConfig = builtins.readFile ../../../files/niri.kdl;
      };

      services.polkit-gnome.enable = true;

      programs.swappy = {
        enable = true;

        settings.Default = {
          save_dir = "$HOME/Pictures/Screenshots";
          save_filename_format = "Screenshot from %Y-%m-%d %H-%M-%S.png";
          show_panel = false;
          early_exit = false;
        };
      };
    };
}
