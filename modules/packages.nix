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
          copyq
          curtail
          dbeaver
          droidcam
          evince
          firefox
          foliate
          gcolor3
          gnuplot
          grim
          hugo
          kooha
          libqalculate
          libreoffice
          nwg-bar
          nwg-displays
          nwg-panel
          obsidian
          pavucontrol
          phockup
          plex
          quarto
          quickemu
          qview
          satty
          slurp
          swaybg
          swaynotificationcenter
          tectonic
          transmission
          vagrant
          ventoy
          vlc
          xarchiver
          zotero
        ])
        ++ (with pkgs.xfce; [
          thunar
          thunar-archive-plugin
          thunar-volman
        ]);
    in
      if isDarwin
      then common ++ darwin
      else common ++ desktop;
  };
}
