{ inputs, ... }:
{
  modules = {
    nixos.core.system-packages =
      { pkgs, ... }:
      {
        environment.systemPackages =
          with pkgs;
          [
            inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
            cachix
            coreutils-full
            dig
            docker-credential-helpers
            egl-wayland
            file
            findutils
            gcc
            gnumake
            gnused
            gzip
            libsecret
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
          ]);
      };

    homeManager.user.packages =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          curl
          elixir
          exiftool
          ffmpeg
          ffmpegthumbnailer
          gdu
          hurl
          imagemagick
          jdk
          jqp
          just
          nix-prefetch-github
          nodejs_latest
          pandoc
          parallel
          pass
          phockup
          prek
          poppler
          python314
          quarto
          sqlite
          tectonic
          terraform
          tpm2-tools
          uv
        ];
      };
  };
}
