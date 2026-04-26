{ inputs, ... }:
{
  modules = {
    homeManager.dev.packages =
      { pkgs, localPackages, ... }:
      {
        home.packages =
          with pkgs;
          [
            curl
            elixir
            hurl
            jdk
            jqp
            just
            nix-prefetch-github
            nodejs_latest
            parallel
            prek
            python314
            sqlite
            uv
          ]
          ++ builtins.attrValues localPackages;
      };

    nixos.core = {
      nixpkgs = {
        nixpkgs.config.allowUnfree = true;
      };

      system-packages =
        {
          pkgs,
          lib,
          config,
          ...
        }:
        {
          environment.systemPackages =
            with pkgs;
            [
              inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
              cachix
              coreutils-full
              dig
              egl-wayland
              file
              findutils
              gcc
              gnumake
              gnused
              gzip
              lsof
              mlocate
              openssl
              p7zip
              psmisc
              rar
              unar
              unzip
              wget
              xdg-utils
              zip
            ]
            ++ (with pkgs.unixtools; [
              net-tools
              netstat
            ])
            ++ lib.optionals (config.machine.type != "server") [
              docker-credential-helpers
              libsecret
            ];
        };
    };
  };
}
