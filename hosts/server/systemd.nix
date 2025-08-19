{
  pkgs,
  parameters,
  config,
  ...
}:
{
  systemd = {
    tmpfiles.rules = [
      "d /mnt/external 2775 1000 1000 -"
      "d /mnt/external/downloads 2775 1000 1000 -"
      "d /mnt/external/downloads/.incomplete 2775 1000 1000 -"
      "d /mnt/external/movies 2775 1000 1000 -"
      "d /mnt/external/tvshows 2775 1000 1000 -"
      "d /var/lib/docker/volumes 2775 1000 1000 -"
    ];
    paths = {
      docker-compose = {
        pathConfig = {
          PathChanged = "${parameters.home}/dotfiles/compose";
          Unit = "docker-compose.service";
        };
      };
      nixos-rebuild-switch = {
        pathConfig = {
          PathChanged = "${parameters.home}/dotfiles/secrets";
          Unit = "nixos-rebuild-switch.service";
        };
      };
    };
    services = {
      nixos-rebuild-switch = {
        description = "NixOS rebuild switch service";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = parameters.user;
          StandardOutput = "journal";
          StandardError = "journal";
          ExecStart = ''
            ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${parameters.home}/dotfiles#${config.networking.hostName}
          '';
        };
      };
      docker-compose = {
        description = "Docker compose systemd service";
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 5;
          StandardOutput = "journal";
          StandardError = "journal";
          WorkingDirectory = "${parameters.home}/dotfiles/compose";
          ExecStart = ''
            ${pkgs.docker}/bin/docker compose --env-file ${
              config.age.secrets."docker-compose.env".path
            } up --detach --remove-orphans
          '';
          ExecStop = ''
            ${pkgs.docker}/bin/docker compose --env-file ${config.age.secrets."docker-compose.env".path} down
          '';
        };
      };
    };
  };
}
