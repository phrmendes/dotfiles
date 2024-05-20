{pkgs, ...}: {
  stylix = {
    image = ../../dotfiles/background.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
    polarity = "dark";
    cursor = {
      name = "Pop";
      package = pkgs.pop-icon-theme;
      size = 28;
    };
    fonts = {
      sizes = {
        applications = 12;
        terminal =
          if pkgs.stdenv.isDarwin
          then 16
          else 12;
      };
      serif = {
        package = pkgs.fira;
        name = "Fira Sans";
      };
      sansSerif = {
        package = pkgs.fira;
        name = "Fira Sans";
      };
      monospace = {
        package = pkgs.fira-code-nerdfont;
        name = "FiraCode Nerd Font Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
