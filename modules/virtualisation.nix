_: {
  modules.nixos.core.virtualisation =
    { pkgs, ... }:
    {
      virtualisation = {
        containers.enable = true;
        docker.rootless = {
          enable = true;
          setSocketVariable = true;
          daemon.settings = {
            storage-driver = "btrfs";
            dns = [
              "8.8.8.8"
              "1.1.1.1"
            ];
          };
        };
      };

      systemd.user.services.docker-prune = {
        description = "Prune unused docker resources";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.docker}/bin/docker system prune --all --force";
          Environment = [ "DOCKER_HOST=unix://%t/docker.sock" ];
        };
      };

      systemd.user.timers.docker-prune = {
        description = "Timer for docker system prune";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = true;
          RandomizedDelaySec = "1h";
        };
      };
    };
}
