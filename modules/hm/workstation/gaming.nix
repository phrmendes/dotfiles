_: {
  modules.homeManager.workstation.gaming =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        heroic
        hydralauncher
        mangohud
        protonup-qt
      ];

      home.sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
      };
    };
}
