{ pkgs, parameters, ... }:
{
  systemd = {
    paths = {
      docker-compose-reload = {
        description = "Watch for changes in Docker Compose configuration";
        pathConfig.PathChanged = "/etc/compose/docker-compose.yaml";
        wantedBy = [ "multi-user.target" ];
      };
      docker-volumes-chown = {
        description = "Watch for new Docker volumes";
        pathConfig.PathChanged = "/var/lib/docker/volumes";
        wantedBy = [ "docker.service" ];
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
      "chown-mnt-external" = {
        description = "Set owner for /mnt/external";
        after = [ "mnt-external.mount" ];
        wantedBy = [ "mnt-external.mount" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.coreutils}/bin/chown -R ${parameters.user}:users /mnt/external";
        };
      };
      "chown-docker-volumes" = {
        description = "Set owner for /var/lib/docker/volumes";
        after = [ "docker.service" ];
        wantedBy = [
          "docker.service"
          "docker-volumes-chown.path"
        ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.coreutils}/bin/chown -R ${parameters.user}:users /var/lib/docker/volumes";
        };
      };
    };
  };
}
