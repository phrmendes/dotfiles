{
  pkgs,
  inputs,
  ...
}: {
  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      kate
      khelpcenter
      oxygen
    ];
    systemPackages = with pkgs; [
      appimage-run
      binutils
      curl
      gnupg
      gnused
      gzip
      psmisc
      rar
      unrar
      unzip
      wget
      wl-clipboard
      xclip
      xdg-utils
      zip
      (pkgs.where-is-my-sddm-theme.override {
        themeConfig = {
          General = {
            background = "${../../dotfiles/background.png}";
          };
        };
      })
    ];
  };
}
