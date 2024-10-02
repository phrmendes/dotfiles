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
      curl
      gcc
      gzip
      mlocate
      p7zip
      psmisc
      rar
      unar
      unzip
      wget
      wl-clipboard
      xdg-utils
      zip
      (where-is-my-sddm-theme.override {
        themeConfig.General = {
          background = "${../../dotfiles/background.png}";
          backgroundMode = "fill";
        };
      })
    ];
  };
}
