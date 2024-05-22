{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin isLinux;
in {
  options.packages.enable = lib.mkEnableOption "enable packages";

  config = lib.mkIf config.packages.enable {
    home.packages = let
      common =
        (with pkgs; [
          ansible
          cachix
          coreutils-full
          curl
          fd
          ffmpegthumbnailer
          file
          findutils
          gcc
          gh
          gnumake
          gnupg
          gnused
          go
          graphviz
          grex
          gzip
          html-tidy
          jdk
          jq
          just
          kind
          kubectl
          kubernetes-helm
          libuv
          libxml2
          ncdu
          opentofu
          pandoc
          parallel
          podman-tui
          poppler
          python312
          rar
          ripgrep
          sqlite
          terraform
          tokei
          unar
          uv
          wget
          zip
        ])
        ++ (with pkgs.nodePackages_latest; [
          nodejs
        ]);
    in
      common
      ++ lib.optionals isDarwin (
        with pkgs; [
          maven
          pngpaste
          terragrunt
        ]
      )
      ++ lib.optionals isLinux (with pkgs; [
        bashly
        bitwarden
        chromium
        copyq
        curtail
        deluge
        droidcam
        evince
        foliate
        gcolor3
        hugo
        kooha
        libqalculate
        libreoffice
        mpv
        neovide
        obsidian
        pavucontrol
        phockup
        plex
        quarto
        quickemu
        qview
        swaybg
        swaynotificationcenter
        syncthingtray
        tectonic
        vagrant
        ventoy
        xarchiver
        zotero
      ]);
  };
}
