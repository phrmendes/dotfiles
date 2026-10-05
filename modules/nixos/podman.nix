{
  nixosModules.podman =
    { ... }:
    {
      virtualisation = {
        podman = {
          enable = true;
          dockerCompat = true;
          dockerSocket.enable = true;
          defaultNetwork.settings.dns_enabled = true;
        };

      };

      systemd = {
        services."user@".serviceConfig.Delegate = "cpu cpuset io memory pids";
        sockets.podman.wantedBy = [ "sockets.target" ];
      };
    };
}
