{
  homeModules.packages = { pkgs, ... }: {
    home.packages =
      (with pkgs; [
        bws
        docker-compose
        jdk
        jqp
        just
        lima
        nix-prefetch-github
        parallel
        pass
        tuicr
      ])
      ++ (with pkgs; [
        android-tools
        deluge
        drawing
        exiftool
        ffmpeg
        ffmpegthumbnailer
        file-roller
        filezilla
        firefox
        gcolor3
        gdu
        grim
        imagemagick
        libqalculate
        libreoffice
        localsend
        pandoc
        pavucontrol
        phockup
        poppler
        proton-vpn
        slurp
        tectonic
        terraform
        tesseract
        thunar
        wf-recorder
        wl-clipboard
        zotero
      ])
      ++ (with pkgs.local; [
        diff-persist
        noctalia-settings-diff
      ]);
  };
}
