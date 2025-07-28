{ inputs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        stable = import inputs.nixpkgs-stable {
          system = final.system;
          config = prev.config;
        };
      })
    ];
  };
}
