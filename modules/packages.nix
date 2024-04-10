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
        poppler
        quarto
        ripgrep
        tectonic
        terraform
        tokei
        unar
      ];
      darwin = with pkgs; [
        maven
        pngpaste
        poetry
        pyenv
        terragrunt
      ];
      desktop = with pkgs; [
        bashly
        copyq
        curtail
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
        nwg-displays
        pavucontrol
        phockup
        plex
        quickemu
        qview
        rofi-power-menu
        satty
        slurp
        swaybg
        transmission
        vagrant
        ventoy
        vlc
      ];
    in
      if isDarwin
      then common ++ darwin
      else common ++ desktop;
  };
}
