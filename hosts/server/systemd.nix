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
      nixos-rebuild-switch = {
        description = "NixOS rebuild switch service";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          WorkingDirectory = "${parameters.home}/dotfiles/compose";
          StandardOutput = "journal";
          StandardError = "journal";
          ExecStart = ''
            ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${parameters.home}/dotfiles#${config.networking.hostName}
          '';
        };
      };
      docker-compose = {
        description = "Docker compose systemd service";
        after = [ "nixos-rebuild-switch.service" ];
        requires = [ "nixos-rebuild-switch.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          WorkingDirectory = "${parameters.home}/dotfiles/compose";
          StandardOutput = "journal";
          StandardError = "journal";
          ExecStartPre = ''
            ${pkgs.coreutils}/bin/chown -R 1000:1000 /mnt/external
            ${pkgs.coreutils}/bin/chown -R 1000:1000 /var/lib/docker/volumes
            ${pkgs.coreutils}/bin/chmod -R 2775 /mnt/external
            ${pkgs.coreutils}/bin/chmod -R 2775 /var/lib/docker/volumes
          '';
          ExecStart = ''
            ${pkgs.docker}/bin/docker compose --env-file ${config.age.secrets.docker-compose-env.path} down
            ${pkgs.docker}/bin/docker compose --env-file ${config.age.secrets.docker-compose-env.path} up --detach --remove-orphans
          '';
          ExecStop = ''
            ${pkgs.docker}/bin/docker compose --env-file ${config.age.secrets.docker-compose-env.path} down
          '';
        };
      };
    };
  };
}
