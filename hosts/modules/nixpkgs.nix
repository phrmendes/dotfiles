{ inputs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: _: {
        stable = import inputs.nixpkgs-stable {
          system = final.stdenv.hostPlatform.system;
          config = {
            allowUnfree = true;
          };
        };
      })
    ];
  };
}
