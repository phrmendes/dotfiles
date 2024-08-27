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

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    curl-nvim = {
      flake = false;
      url = "github:oysandvik94/curl.nvim";
    };

    luasnip-latex-snippets = {
      flake = false;
      url = "github:iurimateus/luasnip-latex-snippets.nvim";
    };

    zotcite = {
      flake = false;
      url = "github:jalvesaq/zotcite";
    };

    cmp-zotcite = {
      flake = false;
      url = "github:jalvesaq/cmp-zotcite";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations = let
      global = rec {
        name = "Pedro Mendes";
        user = "phrmendes";
        email = "pedrohrmendes@proton.me";
        home = "/home/${user}";
        system = "x86_64-linux";
      };
      pkgs = import nixpkgs {
        inherit (global) system;
        config.allowUnfree = true;
      };
    in {
      desktop = let
        parameters =
          {
            device = "/dev/sdc";
          }
          // global;
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

      laptop = let
        parameters =
          {
            device = "/dev/nvme0n1";
          }
          // global;
      in
        nixpkgs.lib.nixosSystem {
          inherit (parameters) system;
          modules = [
            ./hosts/laptop
          ];
          specialArgs = {
            inherit inputs pkgs parameters;
          };
        };
    };
  };
}
