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
          drawing
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
          gnome-screenshot
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
      darwin = with pkgs; let
        az =
          azure-cli.withExtensions
          (with azure-cli-extensions; [amg fzf]);
      in [
        kubelogin
        maven
        pngpaste
        terragrunt
        az
      ];
    in
      common
      ++ lib.optionals isDarwin darwin
      ++ lib.optionals isLinux linux;
  };
}
