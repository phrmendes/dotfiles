{ inputs, ... }:
{
  nix = {
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
    ];
    settings = {
      download-buffer-size = 1048576000;
      auto-optimise-store = true;
      accept-flake-config = true;
      trusted-users = [
        "root"
        "@wheel"
      ];
      experimental-features = [
        "flakes"
        "nix-command"
        "pipe-operators"
      ];
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
