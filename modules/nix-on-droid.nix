{
  lib,
  config,
  inputs,
  ...
}:
{
  options.configurations.nix-on-droid = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
        };
      }
    );
    default = { };
  };

  options.flake.nixOnDroidConfigurations = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = { };
    internal = true;
  };

  config.flake.nixOnDroidConfigurations =
    config.configurations.nix-on-droid
    |> lib.mapAttrs (
      _:
      { module }:
      inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import inputs.nixpkgs {
          system = "aarch64-linux";
        };
        home-manager-path = inputs.home-manager.outPath;
        modules = [ module ];
      }
    );
}
