{
  description = "My personal nixOS/nix-darwin configuration";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://walker.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
    ];
  };

  inputs = {
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    walker.url = "github:abenz1267/walker";
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

    gopher-nvim = {
      flake = false;
      url = "github:olexsmir/gopher.nvim";
    };

    latex-snippets-nvim = {
      flake = false;
      url = "github:iurimateus/luasnip-latex-snippets.nvim";
    };

    mini-nvim = {
      flake = false;
      url = "github:echasnovski/mini.nvim";
    };

    neotest-golang = {
      flake = false;
      url = "github:fredrikaverpil/neotest-golang";
    };

    telescope-zotero = {
      flake = false;
      url = "github:jmbuhr/telescope-zotero.nvim";
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

  outputs = inputs @ {
    self,
    darwin,
    nixpkgs,
    ...
  }: {
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
        specialArgs = {inherit inputs pkgs parameters;};
        modules = [./hosts/darwin];
      };

    nixosConfigurations.desktop = let
      parameters = rec {
        name = "Pedro Mendes";
        user = "phrmendes";
        email = "pedrohrmendes@proton.me";
        home = "/home/${user}";
        system = "x86_64-linux";
        device = "/dev/sdc";
      };
      pkgs = import nixpkgs {
        inherit (parameters) system;
        config.allowUnfree = true;
      };
    in
      nixpkgs.lib.nixosSystem {
        inherit (parameters) system;
        specialArgs = {inherit inputs pkgs parameters;};
        modules = [./hosts/desktop];
      };
  };
}
