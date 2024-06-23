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
          csvlens
          fd
          ffmpegthumbnailer
          file
          findutils
          gdu
          gh
          gcc
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
          opentofu
          pandoc
          parallel
          podman-tui
          poppler
          python312
          rar
          sqlite
          terraform
          tokei
          unar
          wget
          yq-go
          zip
        ])
        ++ (with pkgs.nodePackages_latest; [
          nodejs
        ]);
    in
      common
      ++ lib.optionals isDarwin (
        with pkgs; [
          azure-cli
          maven
          mongosh
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
        obsidian
        pavucontrol
        phockup
        plex
        quarto
        quickemu
        qview
        syncthingtray
        tectonic
        vagrant
        ventoy
        xarchiver
        zotero
      ]);
  };
}
