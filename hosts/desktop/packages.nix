{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      gnumake
      sqlite
      findutils
      appimage-run
      binutils
      coreutils-full
      gcc
      gnupg
      gnused
      gzip
      libnotify
      psmisc
      rar
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
