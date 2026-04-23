_: {
  modules.nixos.core.machine =
    { lib, ... }:
    {
      options.machine = {
        type = lib.mkOption {
          type = lib.types.enum [
            "desktop"
            "laptop"
            "server"
            "container"
          ];
          description = "The machine type, used to select appropriate modules and settings.";
        };
        monitors = {
          primary = lib.mkOption {
            type = lib.types.submodule {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  description = "Hyprland monitor name (e.g. HDMI-A-1, eDP-1).";
                };
                resolution = lib.mkOption {
                  type = lib.types.str;
                  description = "Monitor resolution (e.g. 1920x1080).";
                };
                position = lib.mkOption {
                  type = lib.types.str;
                  description = "Monitor position in the layout (e.g. 0x0).";
                };
              };
            };
            default = {
              name = "virtual";
              resolution = "1920x1080";
              position = "0x0";
            };
            description = "Primary monitor configuration.";
          };
          secondary = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.submodule {
                options = {
                  name = lib.mkOption {
                    type = lib.types.str;
                    description = "Hyprland monitor name (e.g. DP-2).";
                  };
                  resolution = lib.mkOption {
                    type = lib.types.str;
                    description = "Monitor resolution (e.g. 1920x1080).";
                  };
                  position = lib.mkOption {
                    type = lib.types.str;
                    description = "Monitor position in the layout (e.g. 2560x0).";
                  };
                };
              }
            );
            default = null;
            description = "Secondary monitor configuration. Null if no secondary monitor.";
          };
        };
      };
    };
}
