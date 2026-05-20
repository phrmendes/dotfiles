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
        tectonic
        terraform
        thunar
        tpm2-tools
        grim
        satty
        slurp
        tesseract
        (vesktop.overrideAttrs (old: {
          postFixup =
            builtins.replaceStrings
              [ "--enable-features=WaylandWindowDecorations" ]
              [ "--enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer" ]
              old.postFixup;
        }))
        wl-clipboard
        wf-recorder
        zotero
      ];
    };
}
