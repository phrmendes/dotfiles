{ config, ... }:
{
  modules.nixos.server = {
    automation =
      { pkgs, config, ... }:
      let
        dotfiles = "${config.users.users.${config.settings.user}.home}/dotfiles";
        just = "${pkgs.just}/bin/just";
        env = config.age.secrets."docker-compose.env".path;
        compose = "${pkgs.docker-compose}/bin/docker-compose --env-file=${env}";
        basePath = "${pkgs.bash}/bin:${pkgs.just}/bin:${pkgs.git}/bin:${pkgs.coreutils}/bin";
      in
      {
        systemd = {
          timers.git-pull = {
            description = "Timer for git pull dotfiles";
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnCalendar = "*-*-* 06:00,18:00";
              Persistent = true;
              RandomizedDelaySec = "5m";
            };
          };

          services = {
            docker-compose = {
              description = "Docker Compose services";
              after = [
                "docker.service"
                "network-online.target"
              ];
              wants = [ "network-online.target" ];
              requires = [ "docker.service" ];
              bindsTo = [ "docker.service" ];
              wantedBy = [ "multi-user.target" ];
              startLimitIntervalSec = 300;
              startLimitBurst = 3;
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                User = config.settings.user;
                Group = "users";
                WorkingDirectory = "${dotfiles}/compose";
                ExecStart = "${compose} up --detach --remove-orphans --pull missing";
                ExecStop = "${compose} down";
                TimeoutStartSec = 0;
                TimeoutStopSec = 300;
                StandardOutput = "journal";
                StandardError = "journal";
                Restart = "on-failure";
                RestartSec = "30s";
              };
            };

            git-pull = {
              description = "Pull dotfiles from remote";
              after = [ "network-online.target" ];
              wants = [ "network-online.target" ];
              serviceConfig = {
                Type = "oneshot";
                User = config.settings.user;
                Group = "users";
                WorkingDirectory = dotfiles;
                ExecStart = "${just} pull";
                TimeoutStartSec = 120;
                StandardOutput = "journal";
                StandardError = "journal";
                Environment = [ "PATH=${basePath}" ];
              };
            };

            nixos-apply = {
              description = "Apply NixOS configuration if changed";
              after = [ "git-pull.service" ];
              requires = [ "git-pull.service" ];
              serviceConfig = {
                Type = "oneshot";
                WorkingDirectory = dotfiles;
                ExecStart = "${just} apply";
                TimeoutStartSec = 0;
                StandardOutput = "journal";
                StandardError = "journal";
                Environment = [ "PATH=${basePath}:${pkgs.nixos-rebuild}/bin:/run/wrappers/bin" ];
              };
            };

            compose-sync = {
              description = "Sync docker-compose if secrets or compose files changed";
              after = [
                "git-pull.service"
                "nixos-apply.service"
              ];
              requires = [ "git-pull.service" ];
              serviceConfig = {
                Type = "oneshot";
                User = config.settings.user;
                Group = "users";
                WorkingDirectory = dotfiles;
                ExecStart = "${just} compose-sync";
                TimeoutStartSec = 0;
                StandardOutput = "journal";
                StandardError = "journal";
                Environment = [ "PATH=${basePath}:${pkgs.docker-compose}/bin" ];
              };
            };
          };
        };
      };

    persistence = {
      environment.persistence."/persist".users.${config.settings.user}.directories = [
        "dotfiles"
        ".config"
        ".ssh"
        ".local/share"
        ".local/state"
      ];
    };

    tailscale = {
      services.tailscale = {
        useRoutingFeatures = "both";
        extraSetFlags = [
          "--advertise-exit-node"
          "--accept-routes"
          "--advertise-routes=192.168.0.0/24"
        ];
      };
    };

    filesystems = {
      fileSystems."/mnt/external" = {
        device = "/dev/disk/by-label/external";
        fsType = "ext4";
        options = [ "defaults" ];
      };

      systemd.tmpfiles.rules = [
        "d /run/sync 0700 ${config.settings.user} users -"
        "d /mnt/external 2775 ${config.settings.user} users -"
      ];
    };
  };
}
