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
    perSystem = _: {
      treefmt.config = {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          deadnix.enable = true;
          statix.enable = true;
          stylua.enable = true;
          kdlfmt.enable = true;
        };
      };
    };

    flake = {
      nixosConfigurations =
        config.configurations.nixos
        |> lib.mapAttrs (
          _:
          { module }:
          inputs.nixpkgs.lib.nixosSystem {
            modules = [
              inputs.nix-flatpak.nixosModules.nix-flatpak
              module
              {
                nixpkgs.overlays = [
                  (_: prev: {
                    stable = inputs.nixpkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system};
                    local = import ../pkgs {
                      pkgs = prev;
                    };
                  })
                ];
              }
            ];
          }
        );

      checks =
        config.flake.nixosConfigurations
        |> lib.mapAttrsToList (
          name: nixos: {
            ${nixos.config.nixpkgs.hostPlatform.system} = {
              "configurations:nixos:${name}" = nixos.config.system.build.toplevel;
            };
          }
        )
        |> lib.mkMerge;
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
        default = "local.phrmendes.xyz";
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
      description = "Grouped modules: modules.<class>.<group>.<name>";
      type = lib.types.lazyAttrsOf (
        lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule)
      );
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
}
