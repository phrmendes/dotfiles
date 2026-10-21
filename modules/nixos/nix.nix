{ inputs, ... }:
{
  flake.modules.nixos.nix =
    { pkgs, ... }:
    {
      nix.settings = {
        experimental-features = [
          "flakes"
          "nix-command"
          "pipe-operators"
        ];
        extra-substituters = [
          "https://pi.cachix.org"
          "https://nix-community.cachix.org"
        ];
        extra-trusted-public-keys = [
          "pi.cachix.org-1:lGeoGJaZ5ZDabuRzkcD5EBTNnDM4HJ1vqeOxlWk1Flk="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
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
            mlocate
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
        nushell = {
          enable = true;
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

        nh = {
          enable = true;
          clean = {
            enable = true;
            extraArgs = "--keep-since 3d --keep 5";
          };
        };
      };
    };
}
