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
      language-servers = with pkgs; [
        ansible-language-server
        docker-compose-language-service
        dockerfile-language-server-nodejs
        helm-ls            
        marksman
        nil
        taplo
        terraform-ls
        vscode-langservers-extracted                  
        yaml-language-server
        nodePackages.bash-language-server
        python311Packages.python-lsp-server
      ];
      quarto = pkgs.quarto.overrideAttrs (oldAttrs: {
        preFixup = ''
          wrapProgram $out/bin/quarto \
            --prefix QUARTO_DART_SASS : ${lib.getExe pkgs.dart-sass} \
            --prefix QUARTO_DENO : ${lib.getExe pkgs.deno} \
            --prefix QUARTO_ESBUILD : ${lib.getExe pkgs.esbuild} \
            --prefix QUARTO_PANDOC : ${pkgs.quarto}/bin/tools/pandoc \
            --prefix QUARTO_PYTHON : ${pkgs.python3.withPackages (ps: with ps; [jupyter ipython])}/bin/python3 \
            --prefix QUARTO_R : ${pkgs.rWrapper.override {packages = [pkgs.rPackages.rmarkdown];}}/bin/R \
            --prefix QUARTO_TYPST : ${lib.getExe pkgs.typst} \
        '';
        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin $out/share

          mv bin/* $out/bin
          mv share/* $out/share

          runHook postInstall
        '';
      });
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
      ] ++ language-servers;
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
          helix
          hugo
          libreoffice
          logseq
          neovide
          phockup
          plex
          quarto
          quickemu
          syncthingtray
          tectonic
          vagrant
          ventoy
          vscode-fhs
          zellij
          zotero
        ])
        ++ (with pkgs.kdePackages; [
          gwenview
          kcolorchooser
          ktorrent
          okular
          sddm-kcm
          spectacle
        ])
        ++ (with pkgs.libsForQt5; [
          polonium
        ]);
    in
      if isDarwin
      then common ++ darwin
      else common ++ desktop;
  };
}
