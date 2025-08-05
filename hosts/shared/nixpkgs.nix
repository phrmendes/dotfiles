{ inputs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: prev: import ../../pkgs { pkgs = final; })
      (final: prev: {
        stable = import inputs.nixpkgs-stable {
          system = final.system;
          config = prev.config;
        };
      })
    ];
  };
}
