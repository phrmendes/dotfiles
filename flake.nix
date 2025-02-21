{
  description = "My personal nixOS/nix-darwin configuration";

  inputs = {
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    stylix.url = "github:danth/stylix";
    bibli-ls.url = "github:kha-dinh/bibli-ls";

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
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    {
      nixosConfigurations =
        let
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
        in
        {
          desktop =
            let
              parameters = {
                laptop = false;
                device = "/dev/sdc";
                monitors = {
                  primary = "HDMI-A-1";
                  secondary = "DP-1";
                };
              } // global;
            in
            nixpkgs.lib.nixosSystem {
              inherit (parameters) system;
              modules = [ ./hosts/desktop.nix ];
              specialArgs = {
                inherit inputs pkgs parameters;
                nixpkgs.pkgs = pkgs;
              };
            };

          laptop =
            let
              parameters = {
                laptop = true;
                device = "/dev/nvme0n1";
                monitors = {
                  primary = "eDP-1";
                };
              } // global;
            in
            nixpkgs.lib.nixosSystem {
              inherit (parameters) system;
              modules = [ ./hosts/laptop.nix ];
              specialArgs = {
                inherit inputs pkgs parameters;
              };
            };
        };
    };
}
