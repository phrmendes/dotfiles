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
        opentofu
        pandoc
        parallel
        vagrant
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
        terragrunt
      ];
      desktop = with pkgs; [
        bashly
        bitwarden
        bruno
        chromium
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
        grim
        hugo
        libqalculate
        libreoffice
        nwg-displays
        obsidian
        pavucontrol
        peek
        phockup
        plex
        quickemu
        qview
        rofi-power-menu
        satty
        slurp
        swaybg
        syncthingtray
        ventoy
        vlc
        zotero
      ];
    in
      if isDarwin
      then common ++ darwin
      else common ++ desktop;
  };
}
