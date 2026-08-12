{
  lib,
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

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
