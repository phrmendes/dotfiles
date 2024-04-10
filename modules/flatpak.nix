{
  lib,
  config,
  ...
}: {
  options.flatpak.enable = lib.mkEnableOption "enable flatpak";

  config = lib.mkIf config.flatpak.enable {
    services.flatpak = {
      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
      packages = [
        "com.bitwarden.desktop"
        "com.github.zocker_160.SyncThingy"
        "com.usebruno.Bruno"
        "io.dbeaver.DBeaverCommunity"
        "md.obsidian.Obsidian"
        "org.chromium.Chromium"
        "org.zotero.Zotero"
      ];
    };
  };
}
