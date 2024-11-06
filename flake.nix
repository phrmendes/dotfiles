{
  description = "My personal nixOS/nix-darwin configuration";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://wezterm.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    impermanence.url = "github:nix-community/impermanence";
    stylix.url = "github:danth/stylix";
    wezterm.url = "github:wez/wezterm?dir=nix";

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

    efmls-configs-nvim = {
      flake = false;
      url = "github:creativenull/efmls-configs-nvim";
    };

    one-small-step-for-vimkind = {
      flake = false;
      url = "github:jbyuki/one-small-step-for-vimkind";
    };

    luasnip-latex-snippets = {
      flake = false;
      url = "github:iurimateus/luasnip-latex-snippets.nvim";
    };

    kitty-scrollback-nvim = {
      flake = false;
      url = "github:mikesmithgh/kitty-scrollback.nvim";
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
