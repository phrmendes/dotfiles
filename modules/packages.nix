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
          hurl
          jdk
          jq
          just
          kind
          kubectl
          kubernetes-helm
          mongosh
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
          chromium
          curtail
          droidcam
          evince
          firefox
          hugo
          inkscape
          libreoffice
          mupdf
          obsidian
          phockup
          pop-launcher
          qalculate-gtk
          quarto
          quickemu
          syncthingtray
          tectonic
          transmission
          vagrant
          ventoy
          vlc
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
          pop-shell
          sound-output-device-chooser
          user-themes
        ]);
      darwin = with pkgs; [
        azure-cli
        maven
        pngpaste
        terragrunt
      ];
    in
      common
      ++ lib.optionals isDarwin darwin
      ++ lib.optionals isLinux linux;
  };
}
