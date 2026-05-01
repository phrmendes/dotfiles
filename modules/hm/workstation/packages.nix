_: {
  modules.homeManager.workstation.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        android-tools
        deluge-gtk
        drawing
        exiftool
        ffmpeg
        ffmpegthumbnailer
        file-roller
        filezilla
        gcolor3
        gdu
        imagemagick
        libqalculate
        obs-studio
        onlyoffice-desktopeditors
        pandoc
        pass
        pavucontrol
        phockup
        poppler
        proton-vpn
        quarto
        stremio-linux-shell
        tectonic
        terraform
        thunar
        tpm2-tools
        ungoogled-chromium
        grim
        satty
        slurp
        tesseract
        vesktop
        wl-clipboard
        wf-recorder
        zotero
      ];
    };
}
