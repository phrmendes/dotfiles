{
  description = "My personal nixOS/nix-darwin configuration";

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
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
  };

  outputs = inputs @ {
    darwin,
    home-manager,
    nixpkgs,
    nixpkgs-stable,
    ...
  }: {
    darwinConfigurations.macos = darwin.lib.darwinSystem rec {
      system = "aarch64-darwin";
      specialArgs = inputs;
      modules = [
        ./machines/macos
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs;
              pkgs-stable = import nixpkgs-stable {
                inherit system;
                config.allowUnfree = true;
              };
            };
            backupFileExtension = "bak";
            users.prochame.imports = [
              ./machines/macos/home.nix
            ];
          };
        }
      ];
    };

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./machines/nixos
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs;
              pkgs-stable = import nixpkgs-stable {
                inherit system;
                config.allowUnfree = true;
              };
            };
            backupFileExtension = "bak";
            users.phrmendes.imports = [
              ./machines/nixos/home.nix
            ];
          };
        }
      ];
    };
  };
}
