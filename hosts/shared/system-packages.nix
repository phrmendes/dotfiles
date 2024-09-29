{pkgs, ...}: {
  environment = with pkgs; {
    plasma6.excludePackages = with kdePackages; [
      ark
      discover
      dolphin
      dolphin-plugins
      elisa
      gwenview
      kate
      khelpcenter
      konsole
      krdp
      kwallet
      kwallet-pam
      kwalletmanager
    ];
    systemPackages = [
      psmisc
      wl-clipboard
      xdg-utils
      (where-is-my-sddm-theme.override {
        themeConfig.General = {
          background = "${../../dotfiles/background.png}";
          backgroundMode = "fill";
        };
      })
    ];
  };
}
