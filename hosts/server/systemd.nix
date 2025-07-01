{
  pkgs,
  parameters,
  config,
  ...
}:
{
  systemd = {
    paths.docker-compose = {
      pathConfig = {
        PathModified = "${parameters.home}/dotfiles/compose";
        Unit = "docker-compose.service";
      };
    };
    services = {
      docker-compose = {
        description = "Start, stop, and reload Docker Compose services";
        requires = [ "chown-volumes.service" ];
        after = [ "chown-volumes.service" ];
        serviceConfig = {
          Type = "oneshot";
          WorkingDirectory = "${parameters.home}/dotfiles/compose";
          ExecStart = "${pkgs.docker}/bin/docker compose --env-file ${config.age.secrets.docker-compose-env.path} up --detach --remove-orphans";
          ExecStop = "${pkgs.docker}/bin/docker compose --env-file ${config.age.secrets.docker-compose-env.path} down";
          ExecReload = "${pkgs.docker}/bin/docker compose --env-file ${config.age.secrets.docker-compose-env.path} up --detach --remove-orphans";
        };
      };
      chown-volumes = {
        description = "Set owner and permissions for /mnt/external";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''
            ${pkgs.coreutils}/bin/chown -R 1000:1000 /mnt/external
            ${pkgs.coreutils}/bin/chown -R 1000:1000 /var/lib/docker/volumes
            ${pkgs.coreutils}/bin/chmod -R 2775 /mnt/external
            ${pkgs.coreutils}/bin/chmod -R 2775 /var/lib/docker/volumes
          '';
        };
      };
    };
  };
}
