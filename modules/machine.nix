_: {
  modules.nixos.core.machine =
    { lib, config, ... }:
    let
      monitorSubmodule = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Hyprland monitor name (e.g. HDMI-A-1, eDP-1).";
          };
          resolution = lib.mkOption {
            type = lib.types.str;
            description = "Monitor resolution (e.g. 1920x1080).";
          };
          refreshRate = lib.mkOption {
            type = lib.types.int;
            default = 60;
            description = "Monitor refresh rate in Hz.";
          };
          scale = lib.mkOption {
            type = lib.types.float;
            default = 1.0;
            description = "Monitor HiDPI scale factor.";
          };
          position = lib.mkOption {
            type = lib.types.str;
            description = "Monitor position in the layout (e.g. 0x0).";
          };
        };
      };
    in
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
        isWorkstation = lib.mkOption {
          type = lib.types.bool;
          readOnly = true;
          description = "True when the machine type is desktop or laptop.";
        };
        monitors = {
          primary = lib.mkOption {
            type = monitorSubmodule;
            default = {
              name = "virtual";
              resolution = "1920x1080";
              position = "0x0";
            };
            description = "Primary monitor configuration.";
          };
          secondary = lib.mkOption {
            type = lib.types.nullOr monitorSubmodule;
            default = null;
            description = "Secondary monitor configuration. Null if no secondary monitor.";
          };
        };
      };

      config.machine.isWorkstation = config.machine.type == "desktop" || config.machine.type == "laptop";
    };
}
