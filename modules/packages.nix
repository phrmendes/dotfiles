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
          bruno
          chromium
          curtail
          dbeaver
          droidcam
          evince
          firefox
          flameshot
          foliate
          fragments
          gcolor3
          gimp
          gnome-photos
          gnuplot
          grim
          hugo
          libreoffice
          obsidian
          phockup
          plex
          protonmail-bridge-gui
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
          geary
          nautilus
          pomodoro
          gnome-tweaks
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
