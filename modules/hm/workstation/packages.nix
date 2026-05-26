_: {
  modules.homeManager.workstation.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        android-tools
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
        pandoc
        pavucontrol
        phockup
        poppler
        proton-vpn
        qbittorrent
        quarto
        satty
        slurp
        stremio-linux-shell
        tectonic
        terraform
        tesseract
        thunar
        wl-clipboard
        wf-recorder
        zotero
      ];
    };
}
