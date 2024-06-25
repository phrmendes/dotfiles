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
      linux =
        (with pkgs; [
          bitwarden
          bitwarden-cli
          celluloid
          chromium
          curtail
          drawing
          droidcam
          evince
          foliate
          gcolor3
          hugo
          kooha
          libreoffice
          loupe
          neovim-gtk
          obsidian
          pavucontrol
          phockup
          plex
          pop-launcher
          qalculate-gtk
          quarto
          quickemu
          syncthingtray
          tectonic
          transmission
          vagrant
          ventoy
          zotero
        ])
        ++ (with pkgs.gnome; [
          file-roller
          gnome-tweaks
          nautilus
        ])
        ++ (with pkgs.gnomeExtensions; [
          alphabetical-app-grid
          appindicator
          espresso
          just-perfection
          pop-shell
          user-themes
        ]);
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
