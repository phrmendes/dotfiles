_: {
  modules.homeManager.workstation.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
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
        satty
        slurp
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
