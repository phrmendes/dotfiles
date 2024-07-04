{
  pkgs,
  lib,
  ...
}: {
  stylix = let
    inherit (pkgs.stdenv) isLinux;
  in
    {
      enable = true;
      image = ../../dotfiles/background.png;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
      polarity = "dark";
      fonts = {
        sizes = {
          applications = 12;
          terminal =
            if isLinux
            then 12
            else 16;
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
          package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
          name = "FiraCode Nerd Font Mono";
        };
        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
    }
    // lib.optionalAttrs isLinux {
      cursor = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
        size = 26;
      };
    };
}
