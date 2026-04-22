{ inputs, ... }:
{
  modules = {
    nixos.core.system-packages =
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
            wl-clipboard
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

    homeManager.user.packages =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          curl
          elixir
          just
          exiftool
          ffmpeg
          ffmpegthumbnailer
          gdu
          hurl
          imagemagick
          jdk
          jqp
          nix-prefetch-github
          nodejs_latest
          pandoc
          parallel
          pass
          phockup
          poppler
          prek
          python314
          quarto
          sqlite
          stremio-linux-shell
          tectonic
          terraform
          tpm2-tools
          uv
        ];
      };
  };
}
