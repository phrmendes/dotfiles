{
  modules.nixos.server.flaresolverr = {
    services.flaresolverr = {
      enable = true;
      port = 8191;
    };
  };
}
