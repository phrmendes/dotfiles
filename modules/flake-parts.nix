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
      dotfilesDir = lib.mkOption {
        type = lib.types.str;
        default = "${config.settings.home}/Projects/dotfiles";
      };
      serverDomain = lib.mkOption {
        type = lib.types.str;
        default = "local.ohlongjohnson.tech";
      };
      stateVersion = lib.mkOption {
        type = lib.types.str;
        default = "26.11";
      };
      gcp = {
        project = lib.mkOption {
          type = lib.types.str;
          default = "rj-ia-desenvolvimento";
        };
      };
      nvimServerPort = lib.mkOption {
        type = lib.types.port;
        default = 6666;
      };
      podman = {
        subnet = lib.mkOption {
          type = lib.types.str;
          default = "172.18.0.0/16";
        };
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
        serverAddress = lib.mkOption {
          type = lib.types.str;
          default = "192.168.0.2";
        };
        desktopAddress = lib.mkOption {
          type = lib.types.str;
          default = "192.168.0.4";
        };
        kvmAddress = lib.mkOption {
          type = lib.types.str;
          default = "192.168.0.8";
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
