{
  lib,
  inputs,
  config,
  ...
}:
let
  str =
    default:
    lib.mkOption {
      type = lib.types.str;
      inherit default;
    };
in
{
  options = {
    hostPlatform = lib.mkOption {
      type = lib.types.str;
      default = "x86_64-linux";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        options = {
          name = str "Pedro Mendes";
          user = str "phrmendes";
          email = str "pedrohrmendes@proton.me";
          home = str "/home/phrmendes";
          serverDomain = str "server.internal";
          stateVersion = str "26.11";
          logRetention = str "1week";
          lan = {
            interface = str "enp3s0";
            serverAddress = str "192.168.10.2";
            serverMac = str "94:c6:91:aa:e3:9e";
            desktopAddress = str "192.168.10.3";
            laptopAddress = str "192.168.10.4";
          };
          vpn.laptopAddress = str "10.10.10.3";
        };
      };
      default = { };
    };

    flake.modules = lib.mkOption {
      description = "Feature aspects: modules.<class>.<name>";
      type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule);
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
              { nixpkgs.hostPlatform = config.hostPlatform; }
              module
              {
                nixpkgs = {
                  config.allowUnfree = true;
                  overlays = [
                    (_: prev: {
                      stable = inputs.nixpkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system};
                      local = import ../pkgs {
                        inherit inputs;
                        pkgs = prev;
                      };
                    })
                  ];
                };
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
}
