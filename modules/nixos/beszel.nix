{
  nixosModules.beszel =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      port = 8090;
    in
    {
      homepage.services.beszel = {
        dataDir = "/srv/beszel";
        url = "beszel.${config.caddy.domain}";
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
        users.beszel-agent.extraGroups = [ "systemd-journal" ];
      };

      systemd = {
        tmpfiles.rules = [ "d /srv/beszel 0750 beszel-hub beszel-hub -" ];
        services = {
          homepage-dashboard.serviceConfig.EnvironmentFile = config.age.secrets."beszel.env".path;
          beszel-hub.serviceConfig = {
            DynamicUser = lib.mkForce false;
            User = lib.mkForce "beszel-hub";
            Group = lib.mkForce "beszel-hub";
          };
          beszel-agent.serviceConfig.SupplementaryGroups = lib.mkAfter [ "systemd-journal" ];
          beszel-hub-healthcheck = {
            description = "Check Beszel hub health";
            after = [ "beszel-hub.service" ];
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${config.services.beszel.hub.package}/bin/beszel-hub health --url http://127.0.0.1:${toString port}";
              TimeoutStartSec = "5s";
            };
          };
          beszel-agent-healthcheck = {
            description = "Check Beszel agent health";
            after = [ "beszel-agent.service" ];
            serviceConfig = {
              Type = "oneshot";
              User = "beszel-agent";
              ExecStart = "${config.services.beszel.agent.package}/bin/beszel-agent health";
              TimeoutStartSec = "5s";
            };
          };
        };
        timers = {
          beszel-hub-healthcheck-timer = {
            wantedBy = [ "timers.target" ];
            startLimitBurst = 3;
            startLimitIntervalSec = 60;
            timerConfig = {
              OnBootSec = "2m";
              OnUnitActiveSec = "1m";
              Unit = "beszel-hub-healthcheck.service";
            };
          };
          beszel-agent-healthcheck-timer = {
            wantedBy = [ "timers.target" ];
            startLimitBurst = 3;
            startLimitIntervalSec = 60;
            timerConfig = {
              OnBootSec = "2m";
              OnUnitActiveSec = "1m";
              Unit = "beszel-agent-healthcheck.service";
            };
          };
        };
      };

      services = {
        caddy.virtualHosts = config.caddy.mkVhost {
          name = "beszel";
          inherit port;
        };
        beszel = {
          hub = {
            package = pkgs.local.beszel;
            inherit port;
            enable = true;
            dataDir = "/srv/beszel";
            host = "127.0.0.1";
            environment = {
              DISABLE_PASSWORD_AUTH = "true";
              USER_CREATION = "true";
            };
          };
          agent = {
            package = pkgs.local.beszel;
            enable = true;
            environmentFile = config.age.secrets."beszel.env".path;
            environment = {
              HUB_URL = "http://localhost:${toString port}";
              KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN9f/ibSB0GDpqM39d3G5IIa+2iItpIuCi/XYp32o5R0";
              DOCKER_HOST = "unix:///run/podman/podman.sock";
              EXTRA_FILESYSTEMS = "/mnt/external__external";
              SMART_DEVICES = "/dev/sda:sat,/dev/sdb:sat";
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
