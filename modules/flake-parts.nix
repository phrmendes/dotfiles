{
  lib,
  inputs,
  config,
  ...
}:
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
        default = "/home/${config.settings.user}";
      };
      stateVersion = lib.mkOption {
        type = lib.types.str;
        default = "26.05";
      };
      gcp = {
        project = lib.mkOption {
          type = lib.types.str;
          default = "rj-ia-desenvolvimento";
        };
        location = lib.mkOption {
          type = lib.types.str;
          default = "us-east5";
        };
        maasEndpoint = lib.mkOption {
          type = lib.types.functionTo lib.types.str;
          default =
            region:
            "https://aiplatform.googleapis.com/v1/projects/${config.settings.gcp.project}/locations/${region}/endpoints/openapi";
          readOnly = true;
        };
      };
      litellmPort = lib.mkOption {
        type = lib.types.port;
        default = 14141;
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
