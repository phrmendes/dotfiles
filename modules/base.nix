{
  lib,
  inputs,
  config,
  ...
}:
let
  str =
    default: description:
    lib.mkOption {
      type = lib.types.str;
      inherit default description;
    };
  localOverlay = _: prev: {
    local = import ../pkgs {
      inherit inputs;
      pkgs = prev;
    };
  };
in
{
  options = {
    hostPlatform = lib.mkOption {
      type = lib.types.str;
      default = "x86_64-linux";
      description = "System that the configurations are evaluated for.";
    };

    const = lib.mkOption {
      type = lib.types.submodule {
        options = {
          name = str "Pedro Mendes" "Full name, used by git and jujutsu.";
          user = str "phrmendes" "Unix user name.";
          email = str "pedrohrmendes@proton.me" "Email address, used by git and jujutsu.";
          home = str "/home/phrmendes" "Home directory of the user.";
          serverDomain = str "server.internal" "Domain suffix of the server virtual hosts.";
          stateVersion = str "26.11" "NixOS release that tracks nixpkgs. Bump it only on purpose.";
          logRetention = str "1week" "Retention of logs and coredumps, as a systemd time span.";
          generations = lib.mkOption {
            type = lib.types.int;
            default = 2;
            description = "NixOS generations kept in the bootloader.";
          };
          oldRoots = lib.mkOption {
            type = lib.types.int;
            default = 2;
            description = "Retired root subvolumes kept for a rollback.";
          };
          sunshinePort = lib.mkOption {
            type = lib.types.port;
            default = 47990;
            description = "Base port of Sunshine, shared by the service and its proxy.";
          };
          serverInitrdSshPort = lib.mkOption {
            type = lib.types.port;
            default = 2222;
            description = "SSH port of the server initrd.";
          };
          lan = {
            subnet = str "192.168.10.0/24" "LAN subnet in CIDR form.";
            serverAddress = str "192.168.10.2" "LAN address of the server.";
            serverMac = str "94:c6:91:aa:e3:9e" "MAC address of the server, used for wake-on-LAN.";
            desktopAddress = str "192.168.10.3" "LAN address of the desktop.";
            laptopAddress = str "192.168.10.4" "LAN address of the laptop.";
          };
          vpn.laptopAddress = str "10.10.10.3" "WireGuard address of the laptop.";
        };
      };
      default = { };
    };

    flake.modules = lib.mkOption {
      description = "Feature aspects: modules.<class>.<name>";
      type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule);
      default = { };
    };
    configurations = {
      nixos = lib.mkOption {
        type = lib.types.lazyAttrsOf (
          lib.types.submodule {
            options.module = lib.mkOption {
              type = lib.types.deferredModule;
              description = "NixOS module of the host.";
            };
          }
        );
        default = { };
      };
    };
  };

  config = {
    systems = [ "x86_64-linux" ];
    perSystem =
      { config, system, ... }:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShellNoCC {
          packages = [ config.treefmt.build.wrapper ];
        };

        treefmt.config = {
          projectRootFile = "flake.nix";
          programs = {
            nixfmt.enable = true;
            deadnix.enable = true;
            statix.enable = true;
            shfmt.enable = true;
            stylua.enable = true;
          };
          settings.formatter.nufmt = {
            command = "${pkgs.nufmt}/bin/nufmt";
            includes = [ "*.nu" ];
          };
        };

        checks.lint-scripts = pkgs.runCommand "lint-scripts" { nativeBuildInputs = [ pkgs.shellcheck ]; } ''
          for f in ${../files/scripts}/*.sh; do
            ${pkgs.bash}/bin/bash -n "$f"
            shellcheck --rcfile ${../.shellcheckrc} -S error "$f"
          done
          touch $out
        '';
      };

    flake = {
      overlays.local = localOverlay;

      nixosConfigurations =
        config.configurations.nixos
        |> lib.mapAttrs (
          _:
          { module }:
          inputs.nixpkgs.lib.nixosSystem {
            modules = [
              inputs.nix-flatpak.nixosModules.nix-flatpak
              { nixpkgs.hostPlatform = config.hostPlatform; }
              module
              {
                nixpkgs = {
                  config.allowUnfree = true;
                  overlays = [ localOverlay ];
                };
              }
            ];
          }
        );

      checks =
        config.flake.nixosConfigurations
        |> lib.mapAttrsToList (
          name: nixos: {
            ${nixos.config.nixpkgs.hostPlatform.system} = {
              "configurations:nixos:${name}" = nixos.config.system.build.toplevel;
            };
          }
        )
        |> lib.mkMerge;
    };
  };
}
