{
  description = "My personal nixOS/nix-darwin configuration";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    impermanence.url = "github:nix-community/impermanence";
    stylix.url = "github:danth/stylix";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kulala-nvim = {
      flake = false;
      url = "github:mistweaverco/kulala.nvim";
    };

    luasnip-latex-snippets = {
      flake = false;
      url = "github:iurimateus/luasnip-latex-snippets.nvim";
    };
  };

  outputs = {
    darwin,
    nixpkgs,
    ...
  } @ inputs: {
    darwinConfigurations."NTTD-QQ4FN0YXVT" = let
      parameters = rec {
        name = "Pedro Mendes";
        user = "prochame";
        email = "pedro.mendes-ext@ab-inbev.com";
        home = "/Users/${user}";
        system = "aarch64-darwin";
      };
      pkgs = import nixpkgs {
        inherit (parameters) system;
        config.allowUnfree = true;
      };
    in
      darwin.lib.darwinSystem {
        inherit (parameters) system;
        modules = [
          ./hosts/darwin
        ];
        specialArgs = {
          inherit inputs pkgs parameters;
        };
      };

    nixosConfigurations.desktop = let
      parameters = rec {
        name = "Pedro Mendes";
        user = "phrmendes";
        email = "pedrohrmendes@proton.me";
        home = "/home/${user}";
        system = "x86_64-linux";
        device = "/dev/sdc";
        monitors = {
          primary = "HDMI-A-1";
          secondary = "DP-1";
        };
      };
      pkgs = import nixpkgs {
        inherit (parameters) system;
        config.allowUnfree = true;
      };
    in
      nixpkgs.lib.nixosSystem {
        inherit (parameters) system;
        modules = [
          ./hosts/desktop
        ];
        specialArgs = {
          inherit inputs pkgs parameters;
        };
      };
  };
}
