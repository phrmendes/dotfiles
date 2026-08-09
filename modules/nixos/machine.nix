{ lib, ... }:
let
  monitorSubmodule = lib.types.submodule {
    options = {
      name = lib.mkOption { type = lib.types.str; };
      resolution = lib.mkOption { type = lib.types.str; };
      position = lib.mkOption { type = lib.types.str; };
      refreshRate = lib.mkOption {
        type = lib.types.int;
        default = 60;
      };
      scale = lib.mkOption {
        type = lib.types.float;
        default = 1.0;
      };
    };
  };
in
{
  nixosModules.machine =
    { config, lib, ... }:
    {
      options.machine = {
        type = lib.mkOption {
          type = lib.types.enum [
            "desktop"
            "laptop"
            "server"
          ];
          description = "The machine type.";
        };
        dotfilesDir = lib.mkOption {
          type = lib.types.str;
          default = "/home/phrmendes/Projects/dotfiles";
          description = "Path to the dotfiles directory on this machine.";
        };
        isWorkstation = lib.mkOption {
          type = lib.types.bool;
          default = config.machine.type == "desktop" || config.machine.type == "laptop";
          description = "True when type is desktop or laptop.";
        };
        isLaptop = lib.mkOption {
          type = lib.types.bool;
          default = config.machine.type == "laptop";
          description = "True when type is laptop.";
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
            description = "Secondary monitor configuration.";
          };
        };
      };
    };
}
