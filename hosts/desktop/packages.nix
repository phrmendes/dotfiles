{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      appimage-run
      glibc
      libnotify
      psmisc
      wl-clipboard
      xdg-utils
      kdePackages.polkit-kde-agent-1
      (elegant-sddm.override {
        themeConfig.General = {
          background = "${../../dotfiles/background.png}";
        };
      })
    ];
  };
}
