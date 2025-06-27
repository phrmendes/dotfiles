{ pkgs, parameters, ... }:
{
  systemd = {
    paths = {
      docker-compose-reload = {
        description = "Watch for changes in Docker Compose configuration";
        pathConfig.PathChanged = "/etc/compose/docker-compose.yaml";
        wantedBy = [ "multi-user.target" ];
      };
    };
    services = {
      docker-compose = {
        description = "Docker Compose service";
        after = [ "docker.service" ];
        requires = [ "docker.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          WorkingDirectory = "/etc/compose";
          ExecStart = "${pkgs.docker}/bin/docker compose up --detach --remove-orphans";
          ExecStop = "${pkgs.docker}/bin/docker compose down";
          Restart = "always";
          RemainAfterExit = true;
        };
      };
      docker-compose-reload = {
        description = "Reload Docker Compose on config change";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.docker}/bin/docker compose up --detach --remove-orphans";
          WorkingDirectory = "/etc/compose";
        };
      };
      chown-mnt-external = {
        description = "Set owner and permissions for /mnt/external";
        after = [
          "mnt-external.mount"
          "multi-user.target"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''
            ${pkgs.coreutils}/bin/chown -R 1000:1000 /mnt/external
            ${pkgs.coreutils}/bin/chmod -R 2775 /mnt/external
          '';
        };
      };
      chown-docker-volumes = {
        description = "Set owner and permissions for /var/lib/docker/volumes";
        after = [
          "docker.service"
          "multi-user.target"
        ];
        wantedBy = [
          "multi-user.target"
        ];
        serviceConfig = {
          WorkingDirectory = "/etc/compose";
          Type = "oneshot";
          ExecStart = ''
            ${pkgs.coreutils}/bin/chown -R 1000:1000 /var/lib/docker/volumes
            ${pkgs.coreutils}/bin/chmod -R 2775 /var/lib/docker/volumes
            ${pkgs.docker}/bin/docker compose restart
          '';
        };
      };
    };
  };

}
