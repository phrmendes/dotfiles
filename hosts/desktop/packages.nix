{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      appimage-run
      binutils
      coreutils-full
      findutils
      gcc
      gnumake
      gnupg
      gnused
      gzip
      libnotify
      psmisc
      rar
      sqlite
      unrar
      unzip
      wget
      wl-clipboard
      xdg-utils
      zip
      kdePackages.polkit-kde-agent-1
      (elegant-sddm.override {
        themeConfig.General = {
          background = "${../../dotfiles/background.png}";
        };
      })
    ];
  };
}
