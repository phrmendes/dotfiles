{ lib, ... }:
{
  options = {
    hostPlatform = lib.mkOption {
      type = lib.types.str;
      default = "x86_64-linux";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "Pedro Mendes";
        user = "phrmendes";
        email = "pedrohrmendes@proton.me";
        home = "/home/phrmendes";
        serverDomain = "local.phrmendes.xyz";
        stateVersion = "26.11";
        gcpProject = "rj-ia-desenvolvimento";
        nvimServerPort = 6666;
        podmanSubnet = "172.18.0.0/16";
        lan = {
          subnet = "192.168.0.0/24";
          interface = "enp3s0";
          serverAddress = "192.168.0.2";
          desktopAddress = "192.168.0.4";
          kvmAddress = "192.168.0.8";
        };
      };
    };

    nixosModules = lib.mkOption {
      description = "NixOS modules: nixosModules.<name>";
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = { };
    };

    homeModules = lib.mkOption {
      description = "Home-manager modules: homeModules.<name>";
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = { };
    };

    configurations = {
      nixos = lib.mkOption {
        type = lib.types.lazyAttrsOf (
          lib.types.submodule {
            options.module = lib.mkOption {
              type = lib.types.deferredModule;
            };
          }
        );
        default = { };
      };
    };
  };

  config = {
    nixosModules.workstationOptions = {
      options.workstation = lib.mkOption {
        type = lib.types.attrs;
      };
    };

    nixosModules.options =
      { config, lib, ... }:
      let
        inherit (config.dotfilesLib) mkVhost;

        homepageService = { name, ... }: {
          options = {
            dataDir = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            url = lib.mkOption {
              type = lib.types.str;
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
        };
      in
      {
        options.caddy = {
          domain = lib.mkOption {
            type = lib.types.str;
            default = "local.phrmendes.xyz";
            readOnly = true;
          };
          mkVhost = lib.mkOption {
            type = lib.types.anything;
            readOnly = true;
            default = mkVhost config.caddy.domain;
          };
        };

        options.homepage.services = lib.mkOption {
          type = lib.types.attrsOf (lib.types.submodule homepageService);
          default = { };
        };
      };
  };
}
