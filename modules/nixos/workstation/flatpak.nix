{
  modules.nixos.workstation.flatpak = {
    services.flatpak = {
      enable = true;
      packages = [ "app.zen_browser.zen" ];
    };
  };
}
