{ pkgs, ... }:
{

  stylix = {
    enable = true;
    enableReleaseChecks = false;
    image = ../../dotfiles/background.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
    polarity = "dark";
    cursor = {
      name = "Pop";
      package = pkgs.pop-icon-theme;
      size = 26;
    };
    fonts = {
      sizes = {
        applications = 12;
        terminal = 13;
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
        package = pkgs.nerd-fonts.victor-mono;
        name = "VictorMono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    targets = {
      gnome-text-editor.enable = false;
      nixos-icons.enable = false;
    };
  };
}
