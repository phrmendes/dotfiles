{
  pkgs,
  inputs,
  ...
}: {
  environment = let
    colors = import ../../modules/catppuccin.nix;
  in {
    plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      kate
      khelpcenter
      konsole
      oxygen
    ];
    systemPackages = with pkgs; [
      appimage-run
      binutils
      cmake
      coreutils-full
      curl
      gcc
      gcr
      gnumake
      gnupg
      gnused
      gzip
      iconv
      icu
      jdk21
      libuv
      libxml2
      nodejs_21
      psmisc
      python312
      rar
      readline
      sqlite
      unrar
      unzip
      wget
      wl-clipboard
      xclip
      xdg-utils
      zip
      zlib
      (pkgs.where-is-my-sddm-theme.override {
        themeConfig = {
          General = with colors.catppuccin.hex; {
            background = "${../../dotfiles/background.png}";
            basicTextColor = text;
            passwordCharacter = "*";
            passwordFontSize = 20;
            passwordInputBackground = base;
            passwordInputCursorVisible = false;
            passwordInputRadius = 10;
            passwordInputWidth = 0.25;
            passwordMask = true;
            sessionsFontSize = 20;
            usersFontSize = 25;
          };
        };
      })
    ];
  };
}
