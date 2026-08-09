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
