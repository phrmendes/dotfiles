{
  description = "My personal nixOS/nix-darwin configuration";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    scls.url = "github:estin/simple-completion-language-server";
    stylix.url = "github:danth/stylix";

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
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
              device = "/dev/disk/by-id/ata-ADATA_SU630_2M032LSQCCH7";
              monitors = {
                primary = "DP-1";
                secondary = "HDMI-A-1";
              };
            };
          in
          lib.nixosSystem {
            inherit system;
            specialArgs = { inherit inputs parameters; };
            modules = [ ./hosts/desktop ];
          };
        server =
          let
            parameters = global // {
              device = "/dev/disk/by-id/ata-Patriot_Burst_7F6E07090B3B00353759";
              domain = "ohlongjohnson.tech";
            };
          in
          lib.nixosSystem {
            inherit system;
            specialArgs = { inherit inputs parameters; };
            modules = [ ./hosts/server ];
          };
      };
    };
}
