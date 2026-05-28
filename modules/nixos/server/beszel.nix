_: {
  modules.nixos.server.beszel =
    {
      lib,
      config,
      ...
    }:
    let
      port = 8090;
    in
    {
      nixpkgs.overlays = [
        (_: prev: {
          beszel = prev.beszel.overrideAttrs (old: {
            tags = builtins.filter (t: t != "testing") (old.tags or [ ]);
            doCheck = false;
          });
        })
      ];
      server.homepage.services.beszel = {
        dataDir = "/srv/beszel";
        url = "beszel.${config.server.caddy.domain}";
        monitoredServices = [
          "beszel-hub"
          "beszel-agent"
        ];
        homepage = {
          name = "Beszel";
          description = "Server monitoring";
          icon = "sh-beszel";
          category = "Monitoring";
          widget = {
            type = "beszel";
            url = "http://127.0.0.1:${toString port}";
            username = "{{HOMEPAGE_VAR_BESZEL_USERNAME}}";
            password = "{{HOMEPAGE_VAR_BESZEL_PASSWORD}}";
            systemId = "5yswssrqti43j1g";
            version = 2;
            fields = [
              "cpu"
              "memory"
              "disk"
              "network"
            ];
          };
        };
      };

      systemd.services.homepage-dashboard.serviceConfig.EnvironmentFile =
        config.age.secrets."beszel.env".path;

      users = {
        groups = {
          podman.members = [ "beszel-agent" ];
          disk.members = [ "beszel-agent" ];
          beszel-hub = { };
        };
        users.beszel-hub = {
          isSystemUser = true;
          group = "beszel-hub";
        };
      };

      systemd = {
        services.beszel-hub.serviceConfig = {
          DynamicUser = lib.mkForce false;
          User = lib.mkForce "beszel-hub";
          Group = lib.mkForce "beszel-hub";
        };
        tmpfiles.rules = [ "d /srv/beszel 0750 beszel-hub beszel-hub -" ];
      };

      services = {
        caddy.virtualHosts = config.server.caddy.mkVhost "beszel" port;
        beszel = {
          hub = {
            enable = true;
            dataDir = "/srv/beszel";
            host = "127.0.0.1";
            inherit port;
          };
          agent = {
            enable = true;
            environmentFile = config.age.secrets."beszel.env".path;
            environment = {
              HUB_URL = "http://localhost:${toString port}";
              KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN9f/ibSB0GDpqM39d3G5IIa+2iItpIuCi/XYp32o5R0";
              DOCKER_HOST = "unix:///run/podman/podman.sock";
              SMART_DEVICES = "/dev/sda:scsi,/dev/sdb:sat";
              SMART_INTERVAL = "10m";
            };
            smartmon = {
              enable = true;
              deviceAllow = [
                "/dev/sda"
                "/dev/sdb"
              ];
            };
          };
        };
      };
    };
}
