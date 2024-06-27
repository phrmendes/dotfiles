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
          bruno
          cachix
          coreutils-full
          csvlens
          fd
          ffmpegthumbnailer
          file
          findutils
          gcc
          gdu
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
      linux = with pkgs; [
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
        inkscape
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
      ];
      darwin = with pkgs; [
        azure-cli
        maven
        mongosh
        pngpaste
        terragrunt
      ];
    in
      common
      ++ lib.optionals isDarwin darwin
      ++ lib.optionals isLinux linux;
  };
}
