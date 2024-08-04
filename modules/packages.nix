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
          jdk
          jq
          kind
          kubectl
          kubernetes-helm
          libxml2
          mongosh
          opentofu
          pandoc
          parallel
          podman-tui
          poppler
          postgresql
          python312
          quarto
          rar
          terraform
          tokei
          unar
          wget
          zip
        ])
        ++ (with pkgs.nodePackages_latest; [
          nodejs
        ]);
      linux = with pkgs; [
        bitwarden
        chromium
        coursier
        curtail
        deluge
        drawing
        droidcam
        firefox
        gcolor3
        hugo
        inkscape
        libreoffice
        networkmanagerapplet
        obsidian
        pamixer
        pavucontrol
        phockup
        qalculate-gtk
        quickemu
        syncthingtray
        tectonic
        vagrant
        ventoy
        vlc
        zotero
      ];
      darwin = with pkgs; let
        az =
          azure-cli.withExtensions
          (with azure-cli-extensions; [amg fzf]);
      in [
        kubelogin
        maven
        pngpaste
        sqlite
        terragrunt
        az
      ];
    in
      common
      ++ lib.optionals isDarwin darwin
      ++ lib.optionals isLinux linux;
  };
}
