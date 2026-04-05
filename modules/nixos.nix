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
    nixosConfigurations = lib.mapAttrs (
      _:
      { module }:
      inputs.nixpkgs.lib.nixosSystem {
        modules = with inputs; [
          module
          agenix.nixosModules.default
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          impermanence.nixosModules.impermanence
          stylix.nixosModules.stylix
        ];
      }
    ) config.configurations.nixos;

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
