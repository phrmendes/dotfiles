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
          catppuccin-kde
          chromium
          curtail
          dbeaver
          droidcam
          haruna
          hugo
          libreoffice
          neovim-qt
          obsidian
          phockup
          plex
          quarto
          quickemu
          syncthingtray
          tectonic
          vagrant
          ventoy
          zotero
        ])
        ++ (with pkgs.libsForQt5; [polonium])
        ++ (with pkgs.kdePackages; [
          gwenview
          kcolorchooser
          ktorrent
          okular
          sddm-kcm
          spectacle
        ]);
    in
      if isDarwin
      then common ++ darwin
      else common ++ desktop;
  };
}
