{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
in {
  options.packages.enable = lib.mkEnableOption "enable packages";

  config = lib.mkIf config.packages.enable {
    home.packages = let
      common = with pkgs; [
        ansible
        cachix
        fd
        ffmpegthumbnailer
        file
        gh
        graphviz
        grex
        jq
        just
        kind
        kubectl
        kubernetes-helm
        ncdu
        opentofu
        pandoc
        parallel
        podman-tui
        poppler
        ripgrep
        terraform
        tokei
        unar
      ];
      darwin = with pkgs; [
        maven
        pngpaste
        poetry
        terragrunt
      ];
      desktop =
        (with pkgs; [
          bashly
          bitwarden
          gnome-solanum
          bruno
          chromium
          curtail
          dbeaver
          drawing
          droidcam
          evince
          firefox
          foliate
          fragments
          gcolor3
          gnome-photos
          gnuplot
          grim
          hugo
          libreoffice
          obsidian
          phockup
          plex
          qalculate-gtk
          quarto
          quickemu
          syncthingtray
          tectonic
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
          appindicator
          espresso
          forge
          pano
          user-themes
        ]);
    in
      if isDarwin
      then common ++ darwin
      else common ++ desktop;
  };
}
