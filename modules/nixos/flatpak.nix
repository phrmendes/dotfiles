{
  flake.modules.nixos.flatpak = {
    services.flatpak = {
      enable = true;
      packages = [
        "org.zotero.Zotero"
        "com.stremio.Stremio"
      ];
    };
  };
}
