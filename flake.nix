{
  description = "My personal nixOS/nix-darwin configuration";

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
    substituters = ["https://cache.nixos.org/"];
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  };

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs @ {
    darwin,
    home-manager,
    nixpkgs,
    ...
  }: {
    darwinConfigurations.macos = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = inputs;
      modules = [
        ./machines/macos
      ];
    };

    nixOSConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = [
        ./machines/nixos
      ];
    };
  };
}
