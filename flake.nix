{
  description = "My personal nixOS/nix-darwin configuration";

  nixConfig = {
    extra-trusted-public-keys = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    extra-substituters = "https://nix-community.cachix.org";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    telescope-zotero = {
      flake = false;
      url = "github:jmbuhr/telescope-zotero.nvim";
    };

    copilot-chat-nvim = {
      flake = false;
      type = "github";
      owner = "CopilotC-Nvim";
      repo = "CopilotChat.nvim";
      ref = "canary";
    };

    latex-snippets-nvim = {
      flake = false;
      url = "github:iurimateus/luasnip-latex-snippets.nvim";
    };

    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };

    catppuccin-starship = {
      url = "github:catppuccin/starship";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    darwin,
    home-manager,
    nix-flatpak,
    nixpkgs,
    ...
  }: {
    darwinConfigurations."SAO-QQ4FN0YXVT" = let
      parameters = rec {
        email = "pedro.mendes-ext@ab-inbev.com";
        home = "/Users/${user}";
        name = "Pedro Mendes";
        system = "aarch64-darwin";
        user = "prochame";
      };
      pkgs = import nixpkgs {
        inherit (parameters) system;
        config.allowUnfree = true;
      };
    in
      darwin.lib.darwinSystem {
        inherit (parameters) system;
        specialArgs = {
          inherit inputs pkgs parameters;
        };
        modules = [
          ./hosts/darwin
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs pkgs parameters;
              };
              backupFileExtension = "bak";
              users.${parameters.user} = {
                imports = [./modules];

                pyenv.enable = true;
              };
            };
          }
        ];
      };

    nixosConfigurations.desktop = let
      parameters = rec {
        email = "pedrohrmendes@proton.me";
        home = "/home/${user}";
        name = "Pedro Mendes";
        system = "x86_64-linux";
        user = "phrmendes";
      };
      pkgs = import nixpkgs {
        inherit (parameters) system;
        config.allowUnfree = true;
      };
    in
      nixpkgs.lib.nixosSystem {
        inherit (parameters) system;
        specialArgs = {
          inherit inputs pkgs parameters;
        };
        modules = [
          ./hosts/desktop
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs pkgs parameters;
              };
              backupFileExtension = "bak";
              users.${parameters.user} = {
                imports = [
                  nix-flatpak.homeManagerModules.nix-flatpak
                  ./modules
                  ./modules/flatpak.nix
                ];

                blueman.enable = true;
                btop.enable = true;
                dunst.enable = true;
                flatpak.enable = true;
                gnome-keyring.enable = true;
                gtk-theme.enable = true;
                hyprland.enable = true;
                nm-applet.enable = true;
                pasystray.enable = true;
                rofi.enable = true;
                swayidle.enable = true;
                swaylock.enable = true;
                swayosd.enable = true;
                targets.enable = true;
                udiskie.enable = true;
                waybar.enable = true;
              };
            };
          }
        ];
      };
  };
}
