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
      nixos-rebuild-switch = {
        wantedBy = [ "multi-user.target" ];
        pathConfig = {
          PathChanged = "${parameters.home}/dotfiles/secrets";
          Unit = "nixos-rebuild-switch.service";
        };
      };
      docker-compose = {
        wantedBy = [ "multi-user.target" ];
        pathConfig = {
          PathChanged = "${parameters.home}/dotfiles/compose";
          Unit = "docker-compose.service";
        };
      };
    };
    timers = {
      git-pull = {
        description = "Timer for git pull service";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "*-*-* 06:00,18:00";
          Persistent = true;
          RandomizedDelaySec = "5m";
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
          Group = "users";
          StandardOutput = "journal";
          StandardError = "journal";
          ExecStart = "${pkgs.sudo}/bin/sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${parameters.home}/dotfiles#${config.networking.hostName}";
          ExecStartPost = "-${pkgs.sudo}/bin/sudo ${pkgs.systemd}/bin/systemctl reload docker-compose.service";
        };
      };
      docker-compose =
        let
          env = config.age.secrets."docker-compose.env".path;
          compose = "${pkgs.docker-compose}/bin/docker-compose --env-file=${env}";
        in
        {
          description = "Docker Compose services";
          after = [ "docker.service" ];
          wants = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            User = parameters.user;
            Group = "users";
            WorkingDirectory = "${parameters.home}/dotfiles/compose";
            ExecStart = "${pkgs.sudo}/bin/sudo ${compose} up --detach --remove-orphans --force-recreate --pull always";
            ExecStop = "${pkgs.sudo}/bin/sudo ${compose} down";
            ExecReload = "${pkgs.sudo}/bin/sudo ${compose} down; ${pkgs.sudo}/bin/sudo ${compose} up --detach --remove-orphans --force-recreate --pull always";
            TimeoutStartSec = 0;
            TimeoutStopSec = 300;
            StandardOutput = "journal";
            StandardError = "journal";
          };
        };
      git-pull = {
        description = "Git pull dotfiles repository";
        serviceConfig = {
          Type = "oneshot";
          User = parameters.user;
          Group = "users";
          WorkingDirectory = "${parameters.home}/dotfiles";
          ExecStart = "${pkgs.git}/bin/git pull --ff-only";
          StandardOutput = "journal";
          StandardError = "journal";
        };
      };
    };
  };
}
