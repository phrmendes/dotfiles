{
  description = "My personal nixOS/nix-darwin configuration";

  inputs = {
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
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

  };

  outputs =
    inputs@{ nixpkgs, ... }:

    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      global = rec {
        name = "Pedro Mendes";
        user = "phrmendes";
        email = "pedrohrmendes@proton.me";
        home = "/home/${user}";
      };
    in
    {
      nixosConfigurations = {
        desktop =
          let
            parameters = global // {
              device = "/dev/sdc";
              monitors = {
                primary = "HDMI-A-1";
                secondary = "DP-1";
              };
            };
          in
          lib.nixosSystem {
            inherit system;
            specialArgs = { inherit inputs parameters; };
            modules = [ ./hosts/desktop.nix ];
          };
      };
    };
}
