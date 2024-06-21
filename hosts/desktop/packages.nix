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
      (where-is-my-sddm-theme.override {
        themeConfig.General = {
          background = "${../../dotfiles/background.png}";
        };
      })
    ];
  };
}
