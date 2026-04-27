{
  lib,
  config,
  inputs,
  ...
}:
{
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
        };
      }
    );
    default = { };
  };

  config.flake = {
    nixosConfigurations =
      config.configurations.nixos
      |> lib.mapAttrs (
        _:
        { module }:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            module
            {
              nixpkgs.overlays = [
                (final: prev: {
                  stable = inputs.nixpkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system};
                })
              ];
              _module.args.localPackages = pkgs: import ../pkgs { inherit pkgs; };
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
}
