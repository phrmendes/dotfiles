{
  flake.modules.nixos.flatpak = {
    services.flatpak = {
      enable = true;
      packages = [
        "org.zotero.Zotero"
        "com.stremio.Stremio"
      ];
      overrides.settings."org.zotero.Zotero" = {
        "Session Bus Policy"."org.freedesktop.secrets" = "talk";
      };
    };
  };
}
