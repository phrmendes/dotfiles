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

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
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

    curl-nvim = {
      flake = false;
      url = "github:oysandvik94/curl.nvim";
    };

    luasnip-latex-snippets = {
      flake = false;
      url = "github:iurimateus/luasnip-latex-snippets.nvim";
    };

    mini-nvim = {
      flake = false;
      url = "github:echasnovski/mini.nvim";
    };

    nvim-go = {
      flake = false;
      url = "github:crispgm/nvim-go";
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
            laptop = false;
            device = "/dev/sdc";
            monitors = {
              primary = "HDMI-A-1";
              secondary = "DP-1";
            };
          }
          // global;
      in
        nixpkgs.lib.nixosSystem {
          inherit (parameters) system;
          modules = [./hosts/desktop.nix];
          specialArgs = {
            inherit inputs pkgs parameters;
          };
        };

      laptop = let
        parameters =
          {
            laptop = true;
            device = "/dev/nvme0n1";
            monitors = {
              primary = "eDP-1";
            };
          }
          // global;
      in
        nixpkgs.lib.nixosSystem {
          inherit (parameters) system;
          modules = [./hosts/laptop.nix];
          specialArgs = {
            inherit inputs pkgs parameters;
          };
        };
    };
  };
}
