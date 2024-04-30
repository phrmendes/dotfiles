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
          fd
          ffmpegthumbnailer
          file
          gh
          graphviz
          grex
          jdk
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
          python312
          ripgrep
          terraform
          tokei
          unar
        ])
        ++ (with pkgs.nodePackages_latest; [
          nodejs
        ]);
    in
      common
      ++ lib.optionals isDarwin (
        with pkgs; [
          maven
          pngpaste
          terragrunt
        ]
      )
      ++ lib.optionals isLinux (
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
          neovide
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
        ++ (with pkgs.libsForQt5; [
          polonium
        ])
        ++ (with pkgs.kdePackages; [
          gwenview
          kcolorchooser
          ktorrent
          okular
          spectacle
        ])
      );
  };
}
