_: {
  modules.nixos.core.options =
    { lib, ... }:
    {
      options.machine = {
        type = lib.mkOption {
          type = lib.types.enum [
            "desktop"
            "laptop"
            "server"
          ];
        };
        monitors = {
          primary = lib.mkOption {
            type = lib.types.submodule {
              options = {
                name = lib.mkOption { type = lib.types.str; };
                resolution = lib.mkOption { type = lib.types.str; };
                position = lib.mkOption { type = lib.types.str; };
              };
            };
            default = {
              name = "virtual";
              resolution = "1920x1080";
              position = "0x0";
            };
          };
          secondary = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.submodule {
                options = {
                  name = lib.mkOption { type = lib.types.str; };
                  resolution = lib.mkOption { type = lib.types.str; };
                  position = lib.mkOption { type = lib.types.str; };
                };
              }
            );
            default = null;
          };
        };
      };
    };
}
