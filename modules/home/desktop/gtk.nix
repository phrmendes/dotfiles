{
  flake.modules.homeManager.gtk =
    {
      config,
      osConfig,
      pkgs,
      ...
    }:
    let
      inherit (osConfig) stylix;
    in
    {
      stylix.targets.gnome.enable = false;
      stylix.targets.kde.enable = false;

      dconf.settings."org/gnome/desktop/interface" = {
        color-scheme = if stylix.polarity == "dark" then "prefer-dark" else "default";
        font-name = "${stylix.fonts.sansSerif.name} ${toString stylix.fonts.sizes.applications}";
        document-font-name = "${stylix.fonts.serif.name}  ${
          toString (stylix.fonts.sizes.applications - 1)
        }";
        monospace-font-name = "${stylix.fonts.monospace.name} ${toString stylix.fonts.sizes.terminal}";
        icon-theme = config.gtk.iconTheme.name;
        cursor-theme = stylix.cursor.name;
        cursor-size = stylix.cursor.size;
      };

      gtk = {
        enable = true;
        iconTheme = {
          name = "MoreWaita";
          package = pkgs.morewaita-icon-theme;
        };
      };

      qt = {
        enable = true;
        platformTheme.name = "gtk3";
      };
    };
}
