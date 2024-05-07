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
          go
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
      ++ lib.optionals isLinux (with pkgs; [
        bashly
        bitwarden
        bruno
        chromium
        copyq
        curtail
        dbeaver
        droidcam
        evince
        foliate
        gcolor3
        grim
        hugo
        kooha
        libqalculate
        libreoffice
        neovide
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
        syncthingtray
        tectonic
        transmission
        vagrant
        ventoy
        vlc
        xarchiver
        zotero
      ]);
  };
}
