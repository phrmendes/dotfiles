{ lib, inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  config = {
    systems = [ "x86_64-linux" ];
    perSystem =
      { pkgs, ... }:
      {
        formatter = pkgs.nixfmt;
      };
  };

  options = {
    settings = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Pedro Mendes";
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = "phrmendes";
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "pedrohrmendes@proton.me";
      };
      home = lib.mkOption {
        type = lib.types.str;
        default = "/home/phrmendes";
      };
      lan = {
        subnet = lib.mkOption {
          type = lib.types.str;
          default = "192.168.0.0/24";
        };
        interface = lib.mkOption {
          type = lib.types.str;
          default = "enp3s0";
        };
        containerHostAddress = lib.mkOption {
          type = lib.types.str;
          default = "10.250.0.1";
        };
        containerLocalAddress = lib.mkOption {
          type = lib.types.str;
          default = "10.250.0.2";
        };
      };
    };

    modules = lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule)
      );
      default = { };
      description = "Grouped modules: modules.<class>.<group>.<name>";
    };
  };
}
