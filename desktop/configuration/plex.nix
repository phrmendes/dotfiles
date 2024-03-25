{parameters, ...}: {
  services.plex = {
    inherit (parameters) user;
    enable = true;
    openFirewall = true;
  };
}
