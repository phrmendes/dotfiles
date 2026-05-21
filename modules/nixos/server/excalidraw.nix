_: {
  modules.nixos.server.excalidraw =
    { config, ... }:
    let
      port = 4000;
      containerPort = 80;
    in
    {
      server.homepage.services.excalidraw = {
        url = "excalidraw.${config.server.caddy.domain}";
        monitoredServices = [ "podman-excalidraw" ];
        homepage = {
          name = "Excalidraw";
          description = "Virtual whiteboard";
          icon = "sh-excalidraw";
          category = "Services";
        };
      };

      services.caddy.virtualHosts = config.server.caddy.mkVhost "excalidraw" port;

      systemd.services."podman-excalidraw" = {
        after = [ "podman-network-services.service" ];
        requires = [ "podman-network-services.service" ];
      };

      virtualisation.oci-containers.containers.excalidraw = {
        image = "docker.io/excalidraw/excalidraw:latest";
        ports = [ "127.0.0.1:${toString port}:${toString containerPort}" ];
        networks = [ "services" ];
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        extraOptions = [
          "--health-cmd=wget -q --spider http://localhost:${toString containerPort}/"
          "--health-interval=10s"
          "--health-timeout=3s"
          "--health-retries=3"
          "--health-start-period=10s"
        ];
      };
    };
}
