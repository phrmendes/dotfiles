{ inputs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        stable = import inputs.nixpkgs-stable {
          system = final.stdenv.hostPlatform.system;
          config = prev.config;
        };
      })
    ];
  };
}
