{
  description = "My personal NixOS configuration";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    impermanence.url = "github:nix-community/impermanence";
    import-tree.url = "github:vic/import-tree";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-25.11";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    stylix.url = "github:danth/stylix";

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
    inputs:
    let
      global = rec {
        name = "Pedro Mendes";
        user = "phrmendes";
        email = "pedrohrmendes@proton.me";
        home = "/home/${user}";
      };
      desktop = {
        device = "/dev/disk/by-id/ata-ADATA_SU630_2M032LSQCCH7";
        laptop = false;
        monitors = {
          primary = {
            name = "HDMI-A-1";
            resolution = "2560x1080";
            position = "0x0";
          };
          secondary = {
            name = "DP-2";
            resolution = "1920x1080";
            position = "2560x0";
          };
        };
      };
      laptop = {
        device = "/dev/disk/by-id/nvme-IM2P33F8ABR2-256GB_5M182L19BN2C";
        laptop = true;
        monitors = {
          primary = {
            name = "eDP-1";
            resolution = "1920x1080";
            position = "0x0";
          };
        };
      };
      server = {
        device = "/dev/disk/by-id/ata-Patriot_Burst_7F6E07090B3B00353759";
        laptop = false;
      };
    in
    {
      nixosConfigurations = {
        desktop = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/desktop.nix ];
          specialArgs = {
            inherit inputs;
            parameters = global // desktop;
          };
        };

        laptop = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/laptop.nix ];
          specialArgs = {
            inherit inputs;
            parameters = global // laptop;
          };
        };

        server = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/server.nix ];
          specialArgs = {
            inherit inputs;
            parameters = global // server;
          };
        };
      };
    };
}
