_: {
  modules.nixos.server.server-options =
    { lib, ... }:
    {
      options.server.homepage.services = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }:
            {
              options = {
                dataDir = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                };
                url = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                };
                monitoredServices = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ name ];
                };
                homepage = lib.mkOption {
                  type = lib.types.submodule {
                    options = {
                      enable = lib.mkOption {
                        type = lib.types.bool;
                        default = true;
                      };
                      name = lib.mkOption {
                        type = lib.types.str;
                        default = name;
                      };
                      description = lib.mkOption {
                        type = lib.types.str;
                        default = "";
                      };
                      icon = lib.mkOption {
                        type = lib.types.str;
                        default = "${name}.svg";
                      };
                      category = lib.mkOption {
                        type = lib.types.str;
                        default = "Services";
                      };
                      widget = lib.mkOption {
                        type = lib.types.nullOr lib.types.attrs;
                        default = null;
                      };
                    };
                  };
                  default = { };
                };
              };
            }
          )
        );
        default = { };
      };
    };
}
