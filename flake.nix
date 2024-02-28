{
  description = "My personal nixOS/nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cmp-zotcite = {
      flake = false;
      url = "github:jalvesaq/cmp-zotcite";
    };

    mdeval-nvim = {
      flake = false;
      url = "github:jubnzv/mdeval.nvim";
    };

    obsidian-nvim = {
      flake = false;
      url = "github:epwalsh/obsidian.nvim";
    };

    zotcite = {
      flake = false;
      url = "github:jalvesaq/zotcite";
    };

    zsh-nix-shell = {
      flake = false;
      url = "github:chisui/zsh-nix-shell";
    };
  };

  outputs = inputs @ {
    self,
    darwin,
    home-manager,
    nixpkgs,
    ...
  }: {
    darwinConfigurations."SAO-QQ4FN0YXVT" = let
      parameters = rec {
        user = "prochame";
        home = "/Users/${user}";
        system = "aarch64-darwin";
      };
      pkgs = import nixpkgs {
        inherit (parameters) system;
        overlays = [
          inputs.neovim-nightly.overlay
        ];
        config = {
          allowUnfree = true;
        };
      };
    in
      darwin.lib.darwinSystem {
        inherit (parameters) system;
        specialArgs = {
          inherit inputs pkgs parameters;
        };
        modules = [
          ./darwin
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs pkgs parameters;
              };
              backupFileExtension = "bak";
              users.${parameters.user}.imports = [
                ./darwin/home
              ];
            };
          }
        ];
      };

    nixosConfigurations.desktop = let
      parameters = rec {
        user = "phrmendes";
        home = "/home/${user}";
        system = "x86_64-linux";
      };
      pkgs = import nixpkgs {
        inherit (parameters) system;
        overlays = [
          inputs.neovim-nightly.overlay
        ];
        config = {
          allowUnfree = true;
        };
      };
    in
      nixpkgs.lib.nixosSystem {
        inherit (parameters) system;
        specialArgs = {
          inherit inputs pkgs parameters;
        };
        modules = [
          ./desktop
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs pkgs parameters;
              };
              backupFileExtension = "bak";
              users.${parameters.user}.imports = [
                ./desktop/home
              ];
            };
          }
        ];
      };
  };
}
