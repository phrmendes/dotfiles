{
  modules.homeManager.workstation.gtk =
    { pkgs, ... }:
    {
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
