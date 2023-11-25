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
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            extraSpecialArgs = {inherit inputs;};
            backupFileExtension = "bak";
            users.prochame.imports = [
              ./machines/macos/home.nix
            ];
          };
        }
      ];
    };

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = [
        ./machines/nixos
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            extraSpecialArgs = {inherit inputs;};
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
