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
        gh
        graphviz
        grex
        jq
        just
        kubectl
        kubernetes-helm
        mc
        minikube
        opentofu
        pandoc
        parallel
        quarto
        ripgrep
        tectonic
        terraform
        tokei
      ];
      darwin = with pkgs; [
        maven
        pngpaste
        terragrunt
      ];
      desktop =
        (with pkgs; [
          bashly
          bitwarden
          bruno
          chromium
          cliphist
          copyq
          curtail
          dbeaver
          deluge
          droidcam
          evince
          firefox
          foliate
          gcolor3
          gnuplot
          gparted
          grim
          hugo
          libqalculate
          libreoffice
          nwg-displays
          obsidian
          pavucontrol
          peek
          phockup
          quickemu
          qview
          rofi-power-menu
          satty
          slurp
          swaybg
          syncthingtray
          ventoy
          vlc
          wl-clipboard
          zotero
        ])
        ++ (with pkgs.gnome; [
          nautilus
          file-roller
        ]);
    in
      if isDarwin
      then common ++ darwin
      else common ++ desktop;
  };
}
