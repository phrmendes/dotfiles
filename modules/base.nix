{
  lib,
  inputs,
  config,
  ...
}:
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
        serverDomain = "server.internal";
        publicDomain = "phrmendes.xyz";
        stateVersion = "26.11";
        keepOldRoots = 5;
        podmanSubnet = "172.18.0.0/16";
        syncthingDevices = {
          desktop = "GX2DVTR-JHGAK4J-FSWUSWO-T6LXWWV-M7KWB6C-RQHO3YA-XCRMS3P-76YHUAG";
          laptop = "IAG66TX-VIHT5YS-4T7AZBC-IK2OR6D-BHLITJL-H5O27NZ-VGKUTSD-WJ7YIQE";
          phone = "XIO67NF-ENODCEU-AXYLQBT-TNYRTXK-UXOWJX3-S4AZ23F-EIN2CAI-UI6DMQH";
          server = "WO4EEDG-FAZ3VXA-VCV6ZCD-U5TFYFN-QRVFWVO-UXBR4DQ-KDOST52-HD5WNAZ";
          tablet = "N6ESTXQ-B2CWCVM-SHBRV7Y-KOP5JE5-P7CQJ2Q-LQIILS3-NWMBIBU-TTJ74QG";
        };
        lan = {
          interface = "enp3s0";
          serverAddress = "192.168.0.2";
          serverMac = "94:c6:91:aa:e3:9e";
          desktopAddress = "192.168.0.3";
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
                      nufmt = inputs.nufmt.packages.${prev.stdenv.hostPlatform.system}.default;
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
