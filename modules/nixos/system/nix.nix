{ inputs, ... }:
{
  flake.modules.nixos.nix =
    {
      lib,
      pkgs,
      ...
    }:
    {
      nix.optimise.automatic = true;

      nix.settings = {
        experimental-features = [
          "flakes"
          "nix-command"
          "pipe-operators"
        ];
        extra-substituters = [
          "https://pi.cachix.org"
          "https://nix-community.cachix.org"
          "https://noctalia.cachix.org"
          "https://cache.manic.systems"
        ];
        extra-trusted-public-keys = [
          "pi.cachix.org-1:lGeoGJaZ5ZDabuRzkcD5EBTNnDM4HJ1vqeOxlWk1Flk="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          "cache.manic.systems-1:s6OZanN8Us8vRi0jVivP3qlMn0cYHBjBALKrNe5nH8s="
        ];
        trusted-users = [ "@wheel" ];
      };

      environment = {
        persistence."/persist" = {
          hideMounts = true;
          directories = [
            "/etc"
            "/var/db"
            "/var/lib"
            "/var/log"
          ];
        };
        systemPackages =
          with pkgs;
          [
            inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
            cachix
            coreutils-full
            curl
            dig
            docker-credential-helpers
            file
            findutils
            gnused
            gzip
            lsof
            plocate
            openssl
            psmisc
            sqlite
            unzip
            wget
            zip
          ]
          ++ (with pkgs.unixtools; [
            net-tools
            netstat
          ]);
      };

      programs = {
        nano.enable = false;
        fuse.userAllowOther = true;
        command-not-found.enable = false;

        tack = {
          enable = true;
          package = inputs.tack.packages.${pkgs.stdenv.hostPlatform.system}.default;
        };

        nushell = {
          enable = lib.mkDefault true;
          package = pkgs.local.nushell;
        };

        nix-ld = {
          enable = true;
          libraries = with pkgs; [
            glib
            libGL
            libxxf86vm
          ];
        };

      };
    };
}
