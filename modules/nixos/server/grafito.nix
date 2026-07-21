_: {
  modules.nixos.server.grafito =
    { config, pkgs, ... }:
    let
      port = 3001;
    in
    {
      server.homepage.services.grafito = {
        url = "grafito.${config.server.caddy.domain}";
        monitoredServices = [ "grafito.service" ];
        homepage = {
          name = "Grafito";
          description = "Systemd journal log viewer";
          icon = "sh-linux";
          category = "Monitoring";
        };
      };

      services.caddy.virtualHosts = config.server.caddy.mkVhost "grafito" port;

      systemd.sockets.grafito = {
        description = "Socket for Grafito log viewer";
        wantedBy = [ "sockets.target" ];
        listenStreams = [ "127.0.0.1:${toString port}" ];
        socketConfig = {
          NoDelay = true;
          Service = "grafito.service";
        };
      };

      systemd.services.grafito = {
        description = "Grafito journald log viewer";
        after = [ "network.target" ];
        serviceConfig = {
          DynamicUser = true;
          Group = "systemd-journal";
          ExecStart = "${pkgs.local.grafito}/bin/grafito --idle-timeout-sec=300";
          Restart = "on-failure";
        };
      };
    };
}
