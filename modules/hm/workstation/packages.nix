_: {
  modules.homeManager.workstation.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        android-tools
        deluge
        discord
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
        quarto
        satty
        slurp
        stremio-linux-shell
        tectonic
        terraform
        tesseract
        thunar
        wf-recorder
        wl-clipboard
        zotero
      ];
    };
}
