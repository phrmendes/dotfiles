{
  nixosModules.podman =
    { ... }:
    {
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      systemd.sockets.podman.wantedBy = [ "sockets.target" ];
    };
}
