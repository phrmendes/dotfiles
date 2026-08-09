{
  nixosModules.flaresolverr = {
    services.flaresolverr = {
      enable = true;
      port = 8191;
    };
  };
}
