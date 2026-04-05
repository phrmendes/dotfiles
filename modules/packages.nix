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
          deluge-gtk
          drawing
          elixir
          exiftool
          ffmpeg
          ffmpegthumbnailer
          file-roller
          filezilla
          firefox
          gcolor3
          gdu
          grim
          imagemagick
          jdk
          jqp
          just
          kubectl
          kubernetes-helm
          libqalculate
          networkmanagerapplet
          nix-prefetch-github
          nodejs_latest
          obs-studio
          onlyoffice-desktopeditors
          parallel
          pass
          pavucontrol
          phockup
          poppler
          proton-vpn
          python314
          quarto
          tectonic
          terraform
          thunar
          tpm2-tools
          ungoogled-chromium
          uv
          vesktop
          zotero
        ];
      };
  };
}
