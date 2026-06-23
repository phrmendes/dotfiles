_: {
  modules.homeManager.workstation.stremio =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.stremio-linux-shell ];

      xdg.desktopEntries.stremio = {
        name = "Stremio";
        genericName = "Media Center";
        exec = "stremio --ozone-platform=x11 %U";
        icon = "stremio";
        terminal = false;
        categories = [
          "AudioVideo"
          "Player"
          "TV"
        ];
      };
    };
}
