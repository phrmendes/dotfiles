{
  pkgs,
  parameters,
  config,
  ...
}:
{
  systemd.services = {
    docker-compose = {
      description = "Docker Compose service";
      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = "${parameters.home}/compose";
        ExecStart = "${pkgs.docker}/bin/docker compose up --detach --remove-orphans --env-file ${config.age.secrets.docker-compose-env.path}";
        ExecStop = "${pkgs.docker}/bin/docker compose down --env-file ${config.age.secrets.docker-compose-env.path}";
        ExecReload = "${pkgs.docker}/bin/docker compose up --detach --remove-orphans --env-file ${config.age.secrets.docker-compose-env.path}";
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
}
