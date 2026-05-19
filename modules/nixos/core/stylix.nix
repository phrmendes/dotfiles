{ inputs, ... }:
{
  modules.nixos.core.stylix =
    { pkgs, ... }:
    let
      firaFont = {
        package = pkgs.fira;
        name = "Fira Sans";
      };
    in
    {
      imports = [ inputs.stylix.nixosModules.stylix ];
      stylix = {
        enable = true;
        enableReleaseChecks = false;
        image = ../../../files/background.png;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
        polarity = "dark";
        cursor = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
          size = 24;
        };
        fonts = {
          sizes = {
            applications = 12;
            terminal = 13;
          };
          serif = firaFont;
          sansSerif = firaFont;
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
    };
}
