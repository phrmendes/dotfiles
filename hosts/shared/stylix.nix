{ pkgs, ... }:
{
  stylix = {
    enableReleaseChecks = false;
    image = ../../dotfiles/background.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
    polarity = "dark";
    cursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 26;
    };
    fonts = {
      sizes = {
        applications = 12;
        terminal = 13;
      };
      serif = {
        package = pkgs.adwaita-fonts;
        name = "Adwaita Sans";
      };
      sansSerif = {
        package = pkgs.adwaita-fonts;
        name = "Adwaita Sans";
      };
      monospace = {
        package = pkgs.nerd-fonts.meslo-lg;
        name = "MesloLGMDZ Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
