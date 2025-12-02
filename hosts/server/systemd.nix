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
    services = {
      nixos-rebuild-switch = {
        description = "NixOS rebuild switch service";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "root";
          StandardOutput = "journal";
          StandardError = "journal";
          ExecStart = "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake ${parameters.home}/dotfiles#${config.networking.hostName}";
          ExecStartPost = "${pkgs.systemd}/bin/systemctl reload docker-compose.service";
        };
      };
      docker-compose =
        let
          docker-compose-env-path = config.age.secrets."docker-compose.env".path;
          compose-cmd = "${pkgs.docker-compose}/bin/docker-compose --env-file=${docker-compose-env-path}";
        in
        {
          description = "Docker Compose services";
          after = [
            "docker.service"
            "network-online.target"
          ];
          wants = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            User = "root";
            WorkingDirectory = "${parameters.home}/dotfiles/compose";
            ExecStart = "${compose-cmd} up --detach --remove-orphans --force-recreate --pull always";
            ExecStop = "${compose-cmd} down";
            ExecReload = "${compose-cmd} down; ${compose-cmd} up --detach --remove-orphans --force-recreate --pull always";
            TimeoutStartSec = 0;
            TimeoutStopSec = 300;
            StandardOutput = "journal";
            StandardError = "journal";
          };
        };
    };
  };
}
