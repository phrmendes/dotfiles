{
  modules.nixos.server.flaresolverr = _: {
    services.flaresolverr = {
      enable = true;
      port = 8191;
    };
  };
}
