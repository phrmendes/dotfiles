_: {
  modules.homeManager.workstation.stremio =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ stremio-linux-shell ];

      xdg.desktopEntries."com.stremio.Stremio" = {
        name = "Stremio";
        comment = "Freedom To Stream";
        genericName = "Media Center";
        exec = "stremio --ozone-platform=wayland %U";
        icon = "com.stremio.Stremio";
        terminal = false;
        startupNotify = true;
        mimeType = [ "x-scheme-handler/stremio" ];
        categories = [
          "AudioVideo"
          "Player"
          "TV"
        ];
      };
    };
}
